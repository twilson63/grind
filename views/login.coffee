div id: 'login', 'data-role': 'page', ->
  div 'data-role': 'header', ->
    h1 'The Grind'
  div 'data-role': 'content', ->
    form action: '/sessions', method: 'post', ->
      div 'data-role': 'fieldcontain', ->
        label for: 'username', -> 'User'
        input type: 'text', name: 'username', id: 'username', placeholder: 'user name'
      div 'data-role': 'fieldcontain', ->
        label for: 'password', -> 'Password'
        input type: 'password', id: 'password', name: 'password', placeholder: 'password'
        label for: 'password_confirmation', -> 'Password Confirmation'
        input type: 'password', id: 'password_confirmation', name: 'password_confirmation', placeholder: 'password confirmation'
      div 'data-role': 'fieldcontain', ->
        button 'Log In'
        #a href: '#', 'data-role': 'button', -> Sign Up
