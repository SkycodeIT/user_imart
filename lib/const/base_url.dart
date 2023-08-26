class ApiUrl {
  static const baseUrl = 'https://greenhouse-5wj5.onrender.com/';
  // static const baseUrl = 'http://192.168.159.1:3000/';
  static const login = 'login';
  static const sendOtp = 'sendOtp';
  static const verifyOtp = 'verifyOtp';
  static const signUp = 'registration';

  static const category = 'category';
  static const subcategory = 'subcategory';
  static const products = 'products';
  static const productByCatId = 'productByCatId';
  static const productBySubCatId = 'productBySubCatId';
  static const productDetails = 'productDetails';

  static const addToCart = 'add/cart';
  static const checkExistInCart = 'check/cart';
  static const incToCart = 'inc/cart';
  static const decToCart = 'dec/cart';
  static const getCartList = 'cart';
  static const deleteCart = 'delete/cart';

  static const getWishlist = 'wishlist-products';
  static const addWishlist = 'add-wishlist';

  static const getDefaultAddress = 'getDefaultAddress';
  static const updateDefaultAddress = 'updateDefaultAddress';
  static const getAllAddress = 'getAllAddress';
  static const setAddress = 'addAddress';
  static const specificAddress = 'specificAddress';

  static const placeorder = 'placeorder';
  static const allUserOrders = 'allUserOrders';
  static const allOrders = 'allOrders';
  static const addOrderList = 'addOrderList';
  static const orderListSpecificOrder = 'orderListSpecificOrder';
}
