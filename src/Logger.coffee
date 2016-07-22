winston = require 'winston'
util = require 'util'
request = require 'request'
moment = require 'moment'

class Logger

    get: (options) ->
        transports = []
        if options?.console
            transports.push new (winston.transports.Console)
                timestamp: -> moment().format()
                formatter: (options) ->
                    "#{options.timestamp()} | #{options.level.toUpperCase()} - #{options.message or ''}"
        transports.push new (require('winston-daily-rotate-file'))(filename: "./logs/app_log", logstash: true) if options?.file
        # transports.push(new (@newbornsWatcher)(options.name)) if options?.watcher
        new (winston.Logger)(transports: transports)

    newbornsWatcher: (name)->
        console.log name
        CustomLogger = winston.transports.CustomLogger = (options) ->
            @name = 'NewbornsWatcher'
            @level = options.level or 'error'

        util.inherits CustomLogger, winston.Transport
        CustomLogger.prototype.log = (level, msg, meta, callback) ->
            options =
                url: 'https://gcm-http.googleapis.com/gcm/send'
                headers:
                    'Content-Type': 'application/json'
                    'Authorization': 'key=AIzaSyCSx0lhbSz8fhVFjcaI6oFtqprfOO50eVg'
                body:
                    to:'/topics/global'
                    data: 
                        message: 
                            origin: name
                            message: msg
            request.post options, (error, success) ->
                callback error, success
        CustomLogger

module.exports = Logger