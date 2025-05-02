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
const numberSizeDiv = 2.3;
const numberHeight = 0.9;
const numberFontSizeDiv = 0.25;
const dotFontSizeDiv = 0.1;
