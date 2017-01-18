winston = require 'winston'
require 'winston-loggly'
moment = require 'moment'

class Logger

    instance = null

    get: (options) ->
        return instance if instance?
        transports = []

        filepath = options.filepath ? "."

        if options?.console?
            transports.push new (winston.transports.Console)
                timestamp: -> moment().format()
                formatter: (options) ->
                    "#{options.timestamp()} | #{options.level.toUpperCase()} - #{options.message or ''}"
        if options?.file?
            transports.push new (require('winston-daily-rotate-file'))(filename: "#{filepath}/logs/app_log", logstash: true)
        if options?.loggly?
            options =
                level: options.loggly.level or 'warn'
                subdomain: options.loggly.subdomain or 's2way'
                token: options.loggly.token
                tags: options.loggly.tags
                json: true
            transports.push new winston.transports.Loggly options

        # transports.push(new (@newbornsWatcher)(options.name)) if options?.watcher
        instance = new (winston.Logger)(transports: transports)
        instance

    # newbornsWatcher: (name)->
    #     console.log name
    #     CustomLogger = winston.transports.CustomLogger = (options) ->
    #         @name = 'NewbornsWatcher'
    #         @level = options.level or 'error'

    #     util.inherits CustomLogger, winston.Transport
    #     CustomLogger.prototype.log = (level, msg, meta, callback) ->
    #         options =
    #             url: 'https://gcm-http.googleapis.com/gcm/send'
    #             headers:
    #                 'Content-Type': 'application/json'
    #                 'Authorization': 'key=AIzaSyCSx0lhbSz8fhVFjcaI6oFtqprfOO50eVg'
    #             body:
    #                 to:'/topics/global'
    #                 data:
    #                     message:
    #                         origin: name
    #                         message: msg
    #         request.post options, (error, success) ->
    #             callback error, success
    #     CustomLogger

module.exports = Logger
