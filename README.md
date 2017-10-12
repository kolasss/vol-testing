# README

Тестовое приложение по заданию http://jobs.wearevolt.com/me/tasks/2c3f5383-8c45-4352-9f46-60413a6f6bf8

heroku: https://secure-citadel-92820.herokuapp.com/

Аутентификация через JWT. Bearer token header

Для получения токена нужно отправить(все данные в примерах рабочие):

POST https://secure-citadel-92820.herokuapp.com//api/v1/auth
{
	"user": {
		"email": "anahi@anderson.com",
		"password" : "password"
	}
}

придет токен, сохраните его.

Для аутентификации отправялем запрос с хедером вида:

Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdXRoX2lkIjoxLCJpYXQiOjE1MDc4MTUyOTN9.rwATvJfvyGQU8bcRWIT5UKi-4u2lFpppxtYEKp52AmM

POST https://secure-citadel-92820.herokuapp.com/api/v1/posts
{
	"post": {
		"title": "новый титл",
		"body": "новое боди"
	}
}


Страница для загрузки аватара по адресу https://secure-citadel-92820.herokuapp.com/avatar?id=2

  сделан костыль для обхода аутентификации через параметр id, в реальной системе, конечно, этого не будет

Запрос отчета по адресу вида(требуется аутентификация):
https://secure-citadel-92820.herokuapp.com/api/v1/reports/by_author?start_date=2017-10-10T12%3A59%3A10.132Z&end_date=2017-10-10T16%3A59%3A10.132Z&email=test%40test.com
