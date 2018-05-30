class Auth
  prop session default: {
    user: null
  }

  def check
    return (@session:user == null) ? false : true

  def logout
    window:localStorage:_token = null
    @session:user = null

    Imba.commit

  def login user
    window:localStorage:_token = user:token
    @session:user = user
    
    Imba.commit

  def tryLogin callback
    if window:localStorage:_token
      const data = await Connect.fetch 'CURRENT_USER'
      self.login data:user if data:user

    callback && callback()

export var Auth = Auth.new

# Make sure Auth loaded first
import {Connect} from './Connect.imba'