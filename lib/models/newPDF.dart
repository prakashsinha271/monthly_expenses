//SQLite database classes for Mapping data

class CreditDebitClass {
  String id;
  String description;
  String transact;
  String amount;
  String date;

  //Creating Constructor
  CreditDebitClass(
      {this.id, this.description, this.transact, this.amount, this.date});

  //Named Constructor
  CreditDebitClass.withId(
      this.id, this.description, this.transact, this.amount, this.date);

  //MAP for store data
  Map<String, dynamic> toMap() => {
        "id": id,
        "description": description,
        "transact": transact,
        "amount": amount,
        "date": date,
      };

  /*
  factory CreditDebitClass.fromMap(Map<String, dynamic> json) =>
      new CreditDebitClass(
        id: json["id"],
        description: json["description"],
        transact: json["transact"],
        amount: json["amount"],
        date: json["date"],
      );
  // Extract a Note object from a Map object
  CreditDebitClass.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.description = map['description'];
    this.transact = map['transact'];
    this.amount = map['priority'];
    this.date = map['date'];
  }*/

  //MAP for retrieve data
  CreditDebitClass fromMap(Map<String, dynamic> cdMapList) {
    this.id = cdMapList['id'];
    this.description = cdMapList['description'];
    this.transact = cdMapList['transact'];
    this.amount = cdMapList['priority'];
    this.date = cdMapList['date'];
  }
}
