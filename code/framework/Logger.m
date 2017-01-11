classdef Logger
    %LOGGER Receives the data from experiment and saves it to a file
    %   
    %   This class is a singleton to log all actions, the configuration and
    %   the confusion matrix of an experiment.
    %
    %   The action logging is based on a modified log4m class.
    %
    %% Properties Public
    %       logger ... log4m object
    %
    %       filePath . path to the log file
    %
    %       logging .. flag if experiment is running and action logging is
    %                  permitted. 
    %
    %% Properties Private
    %       errorMessage . Error message for action logging
    %
    %% Methods Static
    %       GETLOGGER ............. Returns the instance of the logger or
    %                               creates it if not present
    %       CREATELOGGERSINGLETON . Forces the creation of the logger
    %                               singleton instance
    %
    %% Methods Private
    %       LOGGER . Constructor of the Logger class. Creates log file and
    %                log4m object
    %
    %% Methods Public
    %       STARTEXPERIMENT ........ Log start of experiment and enable
    %                                action logging
    %       STOPEXPERIMENT ......... Log stop of experiment and disable
    %                                action logging
    %       LOGCONFIG .............. Log configuration
    %
    %       LOGCONFIGURATIONMATRIX . Log confusion matrix in log file and
    %                                separate CSV file
    %       LOGFUNCS ............... Functions for different log levels of
    %                                log4m
    %
    % Version: 2017-01-11
    % Author: Tilman Krokotsch
    %%
    
    properties
       
        logger;
        filePath;
        logging;
        
    end
    
    properties (Access = private)
       
        errorMessage;
        
    end
    
    methods (Static)
       
        function obj = getLogger()
            %GETLOGGER Return singleton instance of logger or create it of
            %          not existing
            %
            %% Output
            %   obj . logger instance
            %%
            
            persistent localLogger;
            if isempty(localLogger)
                localLogger = Logger();
            end
            obj = localLogger;
        end
        
        function obj = createLoggerSingleton()
            %CREATELOGGERSINGLETON Return singleton instance of logger or
            %                      create it of not existing
            %
            %% Output
            %   obj . logger instance
            %%
            
            persistent localLogger;
            localLogger = Logger();
            obj = localLogger;
        end
        
    end
    
    methods (Access = private)
       
        function obj = Logger()
            %LOGGER Constructor of Logger class
            %       Initialize log file, log4m object and error. Return
            %       logger object
            %
            %% Output
            %   obj . logger instance
            %%
            
            obj.filePath = ['./experiment_', ...
                            datestr(now, 'yyyymmdd_HHMM'), ...
                            '_log.txt'];
            obj.logger = log4m(obj.filePath);
            obj.logging = false;
            obj.errorMessage = ...
                'Cannot log, when experiment is not running';
            
            fid = fopen(obj.filePath, 'w');
            fprintf(fid, 'HyperSpectralTreeExperiment\n');
            fprintf(fid, '--------------------------------------------\n');
            fclose(fid);
        end
        
    end
    
    methods
        
        function obj = startExperiment(obj)
            %STARTEXPERIMENT Logs start of experiment
            %%
            
            fid = fopen(obj.filePath, 'a');
            fprintf(fid, 'Started: %s\n', datestr(now));
            fclose(fid);
            obj.logging = true;
        end
        
        function obj = stopExperiment(obj)
            %STOPEXPERIMENT Logs stop of experiment
            %%
            
            fid = fopen(obj.filePath, 'a');
            fprintf(fid, 'Stopped: %s\n', datestr(now));
            fprintf(fid, '--------------------------------------------\n');
            fclose(fid);
            obj.logging = false;
        end
        
        function obj = logConfig(obj, ...
                                 classifier, ...
                                 extractors, ...
                                 samplePath, ...
                                 dataPath, ...
                                 crossValParts)
            %LOGCONFIG Logs configuration of experiment
            %%
            
            fid = fopen(obj.filePath, 'a');
            fprintf(fid, 'Classifier:\t%s\n', class(classifier));
            extractorList = cellfun(@class, extractors, ...
                                    'UniformOutput', false);
            fprintf(fid, 'Extractors:\t%s\n', strjoin(extractorList, ', '));
            fprintf(fid, 'Sample Set:\t%s\n', samplePath);
            fprintf(fid, 'Data Set:\t%s\n', dataPath);
            fprintf(fid, 'CrossValParts:\n');
            fclose(fid);
            
            dlmwrite(obj.filePath, ...
                         crossValParts, 'Delimiter', '\t', '-append');
                     
            fid = fopen(obj.filePath, 'a');
            fprintf(fid, '--------------------------------------------\n');
            fclose(fid);
        end
        
        function obj = logConfusionMatrix(obj, confMat)
            %LOGCONFUSIONMATRIX Logs confusion matrix of experiment
            %%
            
            fid = fopen(obj.filePath, 'a');
            fprintf(fid, 'Confusion Matrix:\n');
            fclose(fid);
            dlmwrite(obj.filePath, ...
                         confMat, 'Delimiter', '\t', '-append');
            dlmwrite([obj.filePath(1:end-8), '.csv'], confMat);
        end
        
        function trace(obj, funcName, message)
            %TRACE Log on level trace
            %%
            
            if obj.logging
                obj.logger.trace(funcName, message);
            else
                error(obj.errorStruct);
            end
        end
        
        function debug(obj, funcName, message)
            %TRACE Log on level debug
            %%
            
            if obj.logging
                obj.logger.debug(funcName, message);
            else
                error(obj.errorStruct);
            end
        end
        
 
        function info(obj, funcName, message)
            %TRACE Log on level info
            %%
            
            if obj.logging
                obj.logger.info(funcName, message);
            else
                error(obj.errorMessage);
            end
        end
        

        function warn(obj, funcName, message)
            %TRACE Log on level warn
            %%
            
            if obj.logging
                obj.logger.warn(funcName, message);
            else
                error(obj.errorMessage);
            end
        end
        

        function error(obj, funcName, message)
            %TRACE Log on level error
            %%
            
            if obj.logging
                obj.logger.error(funcName, message);
            else
                error(obj.errorMessage);
            end
        end
        

        function fatal(obj, funcName, message)
            %TRACE Log on level fatal
            %%
            
            if obj.logging
                obj.logger.fatal(funcName, message);
            else
                error(obj.errorMessage);
            end
        end
        
    end
    
end
