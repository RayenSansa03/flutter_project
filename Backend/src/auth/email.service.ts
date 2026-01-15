import { Injectable } from '@nestjs/common';
import * as brevo from '@getbrevo/brevo';

@Injectable()
export class EmailService {
  private apiInstance: brevo.TransactionalEmailsApi;

  constructor() {
    // Initialise Brevo avec la clé API depuis les variables d'environnement
    this.apiInstance = new brevo.TransactionalEmailsApi();
    // Configuration de l'API key pour Brevo
    this.apiInstance.setApiKey(
      brevo.TransactionalEmailsApiApiKeys.apiKey,
      process.env.BREVO_API_KEY || '',
    );
  }

  /**
   * Envoie un email avec HTML personnalisé
   */
  async sendEmail(to: string, subject: string, html: string, text?: string) {
    try {
      // Extraire le nom et l'email depuis EMAIL_FROM
      const fromEmail = process.env.EMAIL_FROM || 'E-Life <charradinoamine@gmail.com>';
      const fromMatch = fromEmail.match(/^(.+?)\s*<(.+?)>$/);
      const senderName = fromMatch
        ? fromMatch[1].trim().replace(/"/g, '')
        : 'E-Life';
      const senderEmail = fromMatch
        ? fromMatch[2].trim()
        : process.env.EMAIL_FROM_ADDRESS || 'charradinoamine@gmail.com';

      const sendSmtpEmail = new brevo.SendSmtpEmail();
      sendSmtpEmail.subject = subject;
      sendSmtpEmail.htmlContent = html;
      sendSmtpEmail.textContent = text || html.replace(/<[^>]*>/g, '');
      sendSmtpEmail.sender = { name: senderName, email: senderEmail };
      sendSmtpEmail.to = [{ email: to }];

      console.log('═══════════════════════════════════════════════════════════');
      console.log('📧 [Brevo] Envoi d\'email en cours...');
      console.log(`   De: ${senderName} <${senderEmail}>`);
      console.log(`   À: ${to}`);
      console.log(`   Sujet: ${subject}`);
      console.log('═══════════════════════════════════════════════════════════');

      const data = await this.apiInstance.sendTransacEmail(sendSmtpEmail);

      const messageId =
        (data as any)?.body?.messageId || (data as any)?.messageId || 'N/A';

      console.log('═══════════════════════════════════════════════════════════');
      console.log('✅ [Brevo] Email accepté par l\'API');
      console.log(`   Message ID: ${messageId}`);
      console.log('═══════════════════════════════════════════════════════════');

      return data;
    } catch (error: any) {
      console.error('❌ Erreur Brevo:', error);
      
      // Extraire le message d'erreur de Brevo
      let errorMessage = 'Erreur inconnue lors de l\'envoi de l\'email';
      
      if (error?.response?.data?.message) {
        errorMessage = error.response.data.message;
      } else if (error?.response?.body?.message) {
        errorMessage = error.response.body.message;
      } else if (error?.message) {
        errorMessage = error.message;
      }
      
      // Message spécial pour l'erreur d'IP non autorisée
      if (error?.response?.status === 401 && errorMessage.includes('unrecognised IP')) {
        errorMessage = 'Votre adresse IP n\'est pas autorisée dans Brevo. Veuillez l\'ajouter dans les paramètres de sécurité Brevo.';
      }
      
      throw new Error(errorMessage);
    }
  }

  /**
   * Envoie un code de vérification par email
   */
  async sendVerificationCode(email: string, code: string, firstName?: string) {
    const html = `
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <style>
            body {
              font-family: Arial, sans-serif;
              line-height: 1.6;
              color: #333;
              max-width: 600px;
              margin: 0 auto;
              padding: 20px;
            }
            .container {
              background-color: #ffffff;
              border-radius: 12px;
              padding: 30px;
              text-align: center;
              box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            .code {
              background-color: #4A90E2;
              color: white;
              font-size: 32px;
              font-weight: bold;
              padding: 15px 30px;
              border-radius: 8px;
              letter-spacing: 8px;
              display: inline-block;
              margin: 20px 0;
            }
            .footer {
              margin-top: 30px;
              font-size: 12px;
              color: #666;
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h2>Code de vérification</h2>
            <p>Bonjour ${firstName || 'Utilisateur'},</p>
            <p>Voici votre code de vérification pour créer votre compte :</p>
            <div class="code">${code}</div>
            <p>Ce code est valide pendant 10 minutes.</p>
            <div class="footer">
              <p>Si vous n'avez pas demandé ce code, ignorez cet email.</p>
            </div>
          </div>
        </body>
      </html>
    `;

    return this.sendEmail(email, 'Votre code de vérification', html);
  }
}
