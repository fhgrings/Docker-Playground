from ..ext.database import db

class Role(db.Model):
    __tablename__ = "Role"
    id_role = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(20))

    def __init__(self, name):
        self.name = name
        db.create_all()

    def dump(self, _indent=0):
        return (
            "   " * _indent
            + repr(self)
            + "\n"
        )
