from src.models.role_permission import RolePermission
from flask import Flask, jsonify, request, make_response
import json
import jwt
import datetime

from src.models.user import User
from src.models.role import Role
from src.models.role_permission import RolePermission
from src.models.permission import Permission
from src.ext.database import db

class LoginService():
    def login(request, app):
        if app.config['public_key'] != request.json['public_key']:
            return make_response("Could not verify!", 401, {"Erro": "Erro"})
        try:
            username = request.json['username']
            password = request.json['password']
        except Exception as e:
            return "Wrong paragemeters", 400

        try:
            user = User.query.filter_by(username=username, password = password).join(Role, Role.id_role == User.id_role).add_columns(User.email, User.phone, User.id_user, User.first_name, User.last_name, User.token, Role.name.label("role")).first()
            if not user:
                return make_response("User or password does not match!", 403, {"Erro": "user or password incorrect"})

            token = jwt.encode({'user': username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(weeks=1)},
                               app.config['SECRET_KEY'])
            user.User.token = token.decode('UTF-8')
            db.session.commit()
            returnable = {
                "user": {
                    "first_name" : user.first_name,
                    "last_name" : user.last_name,
                    "id_user" : user.id_user,
                    "role" : user.role,
                    "email" : user.email,
                    "phone" : user.phone
                },
                "token": token.decode('UTF-8')
            }
            return json.dumps(returnable)
        except Exception as e:
            return str(e), 400
    def getNewToken(request, app):
        token = request.headers.get('Authorization')
        user = jwt.decode(token, app.config['SECRET_KEY'])
        newToken = jwt.encode({'user': user, 'exp': datetime.datetime.utcnow() + datetime.timedelta(weeks=1)}, app.config['SECRET_KEY'])

        return jsonify({'token': newToken.decode('UTF-8')})

    def validateTokenForService(request, app):
        token = request.headers.get("Authorization")
        service = request.args['service']
        isPermited = User.query.filter_by(token=token).join(Role, Role.id_role == User.id_role).join(RolePermission, RolePermission.id_role == Role.id_role).join(Permission, Permission.id_permission == RolePermission.id_permission).filter_by(service_name=service).add_columns(Permission.service_name).first()
        if isPermited: return "ok", 200

        return "Nok", 400

