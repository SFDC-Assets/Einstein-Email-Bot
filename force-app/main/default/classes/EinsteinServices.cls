/*
 * Copyright (c) 2020, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public with sharing class EinsteinServices {

    public static String DEFAULT_NER_MODEL_ID = 'NER7';
    public static String DEFAULT_INTENT_MODEL_ID = 'O5F46QIAFVWW3EGWLCZCNVIVIU';
    public static String DEFAULT_SENTIMENT_MODEL_ID = 'CommunitySentiment';

    public static EinsteinPlay.Einstein_PredictionResult getSentiment(String str, String passedModelId) {
        String modelId = String.isBlank(passedModelId) ? DEFAULT_SENTIMENT_MODEL_ID : passedModelId;

        EinsteinPlay.Einstein_PredictionService service = new EinsteinPlay.Einstein_PredictionService(
            einsteinplay.Einstein_PredictionService.Types.SENTIMENT
        );

        EinsteinPlay.Einstein_PredictionResult prediction;

        try {
            System.debug('Get Sentiment');

            prediction = service.predictSentiment(
                modelId,
                str,
                3,
                ''
            );

            System.debug(prediction);

        } catch (Exception e) {
            System.debug(
                'Sentiment popped: '
                + e.getCause() 
                + '\n' + e.getStackTraceString()
            );
        }

        return prediction;
    }

    public static EinsteinPlay.Einstein_PredictionResult getIntent(String str, String passedIntentModel) {

        String modelId = String.isBlank(passedIntentModel) ? DEFAULT_INTENT_MODEL_ID : passedIntentModel;

        EinsteinPlay.Einstein_PredictionService service = new EinsteinPlay.Einstein_PredictionService(
            EinsteinPlay.Einstein_PredictionService.Types.INTENT
        );

        EinsteinPlay.Einstein_PredictionResult prediction;

        try {
            System.debug('Get Intent');

            prediction = service.predictIntent(
                modelId,
                str,
                3,
                ''
            );

            System.debug(prediction);

        } catch (Exception e) {
            System.debug(
                'Intent popped: '
                + e.getCause() 
                + '\n' + e.getStackTraceString()
            );
        }
        
        return prediction;
    }

    public static EinsteinPlay.Einstein_PredictionResult getNER(String str, String passedModelId) {

        String modelId = String.isBlank(passedModelId) ? DEFAULT_NER_MODEL_ID : passedModelId;

        EinsteinPlay.Einstein_PredictionService service = new EinsteinPlay.Einstein_PredictionService(
            EinsteinPlay.Einstein_PredictionService.Types.NER
        );

        EinsteinPlay.Einstein_PredictionResult prediction;

        try {
            System.debug('Get NER');
    
            prediction = service.predictNER(
                modelId,
                str,
                3,
                ''
            );

            System.debug(prediction);

        } catch (Exception e) {
            System.debug(
                'NER popped: ' 
                + e.getCause() 
                + '\n' + e.getStackTraceString()
            );
        }

        return prediction;
    }
}