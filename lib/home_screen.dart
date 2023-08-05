import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildWordSearch(),
              SizedBox(height: 20),
              _buildGetResults(),
              SizedBox(height: 10,),
              _getSynonyms(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeader () {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/book.png",
              height: 30,
              width: 30,
            ),
            SizedBox(width: 10,),
            Text(
              "THESAURUS",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Compact',
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordSearch () {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded,size: 24,color: Colors.black,),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 2
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2
                ),
                borderRadius: BorderRadius.circular(20)
            ),
            labelText: "Enter Word",
            labelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Compact'
            )
        ),
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'SF Compact',
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buildGetResults () {
    return GestureDetector(
      onTap: (){
        setState((){
          getSynonyms();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "GET RESULTS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'SF Compact',
            ),
          ),
        ),
      ),
    );

  }

  Widget _getSynonyms () {
    return FutureBuilder<List<String>>(
      future: getSynonyms(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> synonyms = snapshot.data ?? [];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 20,
              ),
              itemCount: synonyms.length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    synonyms[index].toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SF Compact',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 50),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrangeAccent,
              ),
            ),
          );
        }
      }, // Add closing parenthesis here
    );
  }

  Future<List<String>> getSynonyms() async {
    List<String> synonyms = [];
    try {
      if (searchController.text == '') {
        print('\n\nRETURNINGGGGGGGGGGGGGGGGGGGGGGGG HERE\n\n');
        return [];
      }
      var queryParams = {'word': searchController.text};
      String url = "api.api-ninjas.com";
      final uri = Uri.https(url, '/v1/thesaurus', queryParams);
      final response = await http.get(uri);
      var responseData = json.decode(response.body);
      for (var prop in responseData['synonyms']) {
        synonyms.add(prop.toString());
      }
      print('\n\nCALLEDDDDDDDDDDDDDDD HEasdfaRE\n\n' + synonyms.toString());
    } catch (e) {
      debugPrint("Some exception occurred 111: " + e.toString());
      debugPrint("Three");
    }
    return synonyms;
  }

}
