# Configuration Brevo - Résolution des problèmes

## Problème : Erreur 401 - IP non autorisée

Si vous recevez l'erreur suivante :
```
We have detected you are using an unrecognised IP address [VOTRE_IP]. 
If you performed this action make sure to add the new IP address in this link: 
https://app.brevo.com/security/authorised_ips
```

## Solution

### 1. Autoriser votre adresse IP dans Brevo

1. Connectez-vous à votre compte Brevo : https://app.brevo.com/
2. Allez dans **Settings** → **Security** → **Authorised IPs**
3. Cliquez sur **Add IP address**
4. Ajoutez votre adresse IP actuelle (visible dans le message d'erreur)
5. Confirmez l'ajout

### 2. Vérifier l'adresse d'expéditeur

Assurez-vous que l'adresse email d'expéditeur est vérifiée dans Brevo :

1. Allez dans **Settings** → **Senders & IP**
2. Vérifiez que `charradinoamine@gmail.com` est bien vérifiée
3. Si ce n'est pas le cas, cliquez sur **Verify** et suivez les instructions

### 3. Variables d'environnement

Vérifiez que votre fichier `.env` contient bien :

```env
BREVO_API_KEY=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
EMAIL_FROM=E-Life <charradinoamine@gmail.com>
EMAIL_FROM_ADDRESS=charradinoamine@gmail.com
```

### 4. Redémarrer le serveur

Après avoir autorisé votre IP, redémarrez le serveur backend :

```bash
npm run start:dev
```

## Test

Pour tester l'envoi d'email, utilisez l'endpoint d'inscription :

```bash
POST http://localhost:3000/api/auth/register
Content-Type: application/json

{
  "email": "votre-email@example.com",
  "password": "votre-mot-de-passe",
  "firstName": "Prénom",
  "lastName": "Nom"
}
```

Vous devriez recevoir un code de vérification par email.

## Notes importantes

- **En développement** : Vous pouvez désactiver temporairement la restriction IP dans Brevo pour faciliter les tests
- **En production** : Il est recommandé de garder la restriction IP activée pour la sécurité
- **IP dynamique** : Si votre IP change souvent, vous pouvez utiliser un service de whitelist dynamique ou désactiver temporairement la restriction
