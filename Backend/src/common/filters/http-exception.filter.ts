/**
 * Filtre global pour la gestion des exceptions HTTP
 * Transforme les exceptions en réponses HTTP standardisées
 */

import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    console.error('--- Exception Caught in Filter ---');
    console.error(`Status: ${status}`);
    if (exception instanceof HttpException) {
      console.error('Response details:', JSON.stringify(exception.getResponse(), null, 2));
    } else {
      console.error('Exception details:', exception);
    }
    console.error('----------------------------------');

    let message: string;
    if (exception instanceof HttpException) {
      const response = exception.getResponse();
      if (typeof response === 'string') {
        message = response;
      } else if (typeof response === 'object' && response !== null) {
        message = (response as any).message || exception.message || 'Une erreur est survenue';
        // Si message est un tableau (erreurs de validation), prendre le premier élément
        if (Array.isArray(message)) {
          message = message[0] || 'Erreur de validation';
        }
      } else {
        message = exception.message || 'Une erreur est survenue';
      }
    } else {
      message = 'Internal server error';
    }

    response.status(status).json({
      success: false,
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message,
    });
  }
}
