# Rails Interview

## Objective

This project contains two models, Users and Comments, where a Comment belongs to a User.

The work is divided into a number of stages:

### Basic Comments controller
Create a basic Comments controller that only returns all comments.

> Use guard with existing tests to verify your implementation by running: `bundle exec guard`

### Add pagination
Allow users to pass `page=` and `limit=` as query params, to limit the results returned and support pagination.

### Add filtering 
Allow users to pass `content=` as query params, to limit results only to those Comments that contain the passed value.

### Add nested filtering
Allow users to pass `user_name=` and `user_email=`, to limit results to those Comments that their users have the appropriate values in their name and/or email.

### Extract code 
Extract the code into a shared library

### Users controller
Use the shared library to add pagination and filtering to the Users controller, filtered by `name=` and `email=`
