enum Resource {
  grau('Grau'),
  oaie('Oaie'),
  lemn('Lemn'),
  argila('Argila'),
  piatra('Piatra'),
  desert('Desert');

  final String title;
  const Resource(this.title);

  @override
  String toString() => title;
}

const offsetHorizontalSpacing = 0.92;
const offsetVerticalSpacing = 0.76;
const lowerLimit = 89;
const upperLimit = 140;
