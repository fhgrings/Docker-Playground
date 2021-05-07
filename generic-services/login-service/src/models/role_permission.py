from ..ext.database import db

class RolePermission(db.Model):
    __tablename__ = "RolePermission"
    id_role_permission = db.Column(db.Integer, primary_key=True)
    id_role = db.Column(db.Integer, primary_key=True)
    id_permission = db.Column(db.Integer, primary_key=True)

    def __init__(self, name, id_permission):
        self.name = name
        db.create_all()

    def dump(self, _indent=0):
        return (
            "   " * _indent
            + repr(self)
            + "\n"
        )
