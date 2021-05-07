from ..ext.database import db

class Permission(db.Model):
    __tablename__ = "Permission"
    id_permission = db.Column(db.Integer, primary_key=True)
    service_name = db.Column(db.String(20))
    def __init__(self, service_name):
        self.service_name = service_name
        db.create_all()

    def dump(self, _indent=0):
        return (
            "   " * _indent
            + repr(self)
            + "\n"
        )
