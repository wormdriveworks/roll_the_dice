class Options {
  final bool activeControl;
  final double appVer;

  const Options({
    required this.activeControl,
    required this.appVer,
  });

  factory Options.initial() {
    return const Options(
      activeControl: true,
      appVer: 1.0,
    );
  }

  factory Options.fromMap(Map<String, dynamic> map) {
    return Options(
      activeControl: map['activeControl'] == 1,
      appVer: map['appVer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeControl': activeControl ? 1 : 0,
      'appVer': appVer,
    };
  }

  @override
  List<Object> get props {
    return [
      activeControl,
      appVer,
    ];
  }

  @override
  bool get stringify => true;
}
