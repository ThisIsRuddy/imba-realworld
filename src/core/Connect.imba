import {ApiAgent} from './ApiAgent.imba'
import {toQueryString} from '../global/Helper.imba'

class Connect
  prop api default: ApiAgent.new
  prop session default: {
    user: null
  }

  def checkAuth
    return (@session:user == null) ? false : true

  def setAuth user
    window:localStorage:_token = user:token
    @session:user = user
  
  def fetch key, query
    # Set Request Headers
    const extra  = @api.endpoints[key][2]
    let headers = Headers.new
    headers.append 'Content-type', 'application/json'
    if extra && extra:auth
      headers.append 'Authorization', 'Token ' + window:localStorage:_token

    # Set Request Params
    const method = @api.endpoints[key][0]
    let params = { headers: headers, method : method }
    if query && method == 'POST'
      params:body = JSON.stringify query

    # Set Request URL
    let url = @api.root + @api.endpoints[key][1]
    if query && method == 'GET'
      url = url + '?' + toQueryString query
    
    # Fetch request
    const res = await window.fetch url, params
    return res.json

export var Connect = Connect.new