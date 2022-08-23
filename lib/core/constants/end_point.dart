class EndPoint {


  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const apiKey = '35ef0461fc4557cf1d256d3335ed7545';


  static search(page,query) => 'search/movie?api_key=$apiKey&language=en-US&page=$page&query=$query';
  static movieDetail(id) => 'movie/$id?api_key=$apiKey&language=en-US';
}
