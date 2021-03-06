debug     = require('debug')('meshblu-core-protocol-adapter-http:subscription-controller')
_         = require 'lodash'
JobToHttp = require '../helpers/job-to-http'

class SubscriptionsController
  constructor: ({@jobManager, @jobToHttp}) ->

  list: (req, res) =>
    job = @jobToHttp.httpToJob jobType: 'SubscriptionList', request: req, toUuid: req.params.uuid

    @jobManager.do job, (error, jobResponse) =>
      return res.sendError error if error?
      return res.sendError new Error('Did not receive jobResponse') unless jobResponse?
      @jobToHttp.sendJobResponse {jobResponse, res}

  create: (req, res) =>
    req.body = _.pick req.params, ['subscriberUuid', 'emitterUuid', 'type']
    job = @jobToHttp.httpToJob jobType: 'CreateSubscription', request: req, toUuid: req.params.subscriberUuid

    @jobManager.do job, (error, jobResponse) =>
      return res.sendError error if error?
      return res.sendError new Error('Did not receive jobResponse') unless jobResponse?
      jobResponse.metadata.code = 204 if jobResponse.metadata.code == 304
      jobResponse.metadata.code = 204 if jobResponse.metadata.code == 201
      @jobToHttp.sendJobResponse {jobResponse, res}

  remove: (req, res) =>
    req.body = _.pick req.params, ['subscriberUuid', 'emitterUuid', 'type']
    job = @jobToHttp.httpToJob jobType: 'RemoveSubscription', request: req, toUuid: req.params.subscriberUuid

    @jobManager.do job, (error, jobResponse) =>
      return res.sendError error if error?
      return res.sendError new Error('Did not receive jobResponse') unless jobResponse?
      @jobToHttp.sendJobResponse {jobResponse, res}

  removeMany: (req, res) =>
    req.body = _.pick req.body, ['emitterUuid', 'type']
    job = @jobToHttp.httpToJob jobType: 'RemoveSubscriptions', request: req, toUuid: req.params.subscriberUuid

    @jobManager.do job, (error, jobResponse) =>
      return res.sendError error if error?
      return res.sendError new Error('Did not receive jobResponse') unless jobResponse?
      @jobToHttp.sendJobResponse {jobResponse, res}

module.exports = SubscriptionsController
