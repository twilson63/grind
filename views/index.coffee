doctype 5
html ->
  head ->
    title 'The Grind'
    meta charset: 'utf-8'
    
    # ## Remember to include for mobile devices
    # Required for JQuery Mobile to attach to the mobile device's height and width
    meta name: 'viewport', content:'width=device-width, minimum-scale=1, maximum-scale=1'
    meta(name: 'description', content: @description) if @description?
    
    # ## Remove Chrome from iOS
    # This meta tag removes the chrome from the iOS Browser
    # to provide a more native application feel
    meta name: 'apple-mobile-web-app-capable', content: 'yes'
    link(rel: 'canonical', href: @canonical) if @canonical?

    link rel: 'icon', href: '/favicon.png'

    # Pulling in jQM's Stylesheets that support default styling for jQM
    link href: 'http://code.jquery.com/mobile/latest/jquery.mobile.min.css', rel: 'stylesheet', type: 'text/css'
  body ->
    # Include Extension in CoffeeMate
    # In Order to render includes in coffeekup need to add
    # text at the begining for Coffeemate 0.2.3 - 
    # should be improved in later version, it is an 
    # issue with coffeekup, not coffeemate
    text @include 'login'
    text @include 'home'
    text @include 'new'
    text @include 'show'
    text @include 'edit'
    text @include 'status_new'
    text @include 'templates'
    text @include 'client'



