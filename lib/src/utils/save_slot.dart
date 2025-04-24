class SaveSlot {
  final int slotIndex;
  final DateTime? updatedDate;

  const SaveSlot({
    required this.slotIndex,
    this.updatedDate,
  });

  factory SaveSlot.fromMap(Map<String, dynamic> map) {
    return SaveSlot(
      slotIndex: map['slot_index'],
      updatedDate: DateTime.parse(map['updated_date']).toLocal(),
    );
  }

  @override
  List<Object?> get props {
    return [
      slotIndex,
      updatedDate,
    ];
  }

  @override
  bool get stringify => true;
}
