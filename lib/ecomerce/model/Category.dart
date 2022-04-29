class Category {
  final int id;
  final String mainCategory;
  final String mainCategoryEnglish;
  final String image;
  final List<String> subCategories;
  final List<String> subCategoriesEnglish;
  final String showCategories;
  final String homeCategoriesStyle;
  final String mainCategoriesStyle;
  Category({
    this.id,
    this.mainCategory,
    this.mainCategoryEnglish,
    this.subCategories,
    this.subCategoriesEnglish,
    this.image,
    this.showCategories,
    this.homeCategoriesStyle,
    this.mainCategoriesStyle,
  });}