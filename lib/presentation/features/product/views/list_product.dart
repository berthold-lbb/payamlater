import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../details/views/detail_product.dart';
import '../../salesperson/home/views/home_salesperson.dart';
import '../controller/listP_controller.dart';
import '../model/category.dart';
import '../model/product_model.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({Key? key}) : super(key: key);

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  ProductController productController = Get.put(ProductController());
  List<String> listImage = [];
  int selectedSliderPosition = 0;

  final currencyE = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    super.initState();
    sliderImage();
  }

  void sliderImage() {
    listImage.add("assets/images/moto1.jpeg");
    listImage.add("assets/images/moto1.jpeg");
    listImage.add("assets/images/moto1.jpeg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // brightness: Brightness.dark,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 10, top: 10),
          padding: EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              // Navigator.pop(context);
              Get.off(SalesDashBoard());
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            // '${productController.productModel?.nameCat}',
            "catalog".toUpperCase(),
            style: TextStyle(
              color: Color(0xFF1B1D3B),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //       icon: Align(
        //         widthFactor: 1.0,
        //         heightFactor: 1.0,
        //         child: Icon(
        //           Icons.shopping_bag_outlined,
        //           color: Colors.black,
        //         ),
        //       ),
        //       onPressed: () {}),
        //   // Transform.translate(
        //   //     offset: Offset(5 * 0.5, 0),
        //   //     child: IconButton(
        //   //         icon: Align(
        //   //           widthFactor: 1.0,
        //   //           heightFactor: 1.0,
        //   //           child: Icon(
        //   //             Icons.account_circle,
        //   //             color: Colors.black,
        //   //           ),
        //   //         ),
        //   //         onPressed: () {})),
        // ],
      ),
      extendBody: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 15),
              // SearchBar(),
              SizedBox(height: 20),
              Text(
                'Shop by Categories',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),
              ),
              // SizedBox(height: 15),
              //Get list categories
              FutureBuilder<List<CategoryModel?>?>(
                future: productController
                    .getCategory(),
                builder: (context, snapshot) {
                  List<CategoryModel?> category =
                      snapshot.data ?? [];
                return Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: category.length,
                        itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          // onTap: ,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/motor.png',
                                    height: 100,
                                    width: 85,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        // Add one stop for each color. Stops should increase from 0 to 1
                                        stops: [0.2, 0.7],
                                        colors: [
                                          Color.fromARGB(100, 0, 0, 0),
                                          Color.fromARGB(100, 0, 0, 0),
                                        ],
                                      ),
                                    ),
                                    height: 100,
                                    width: 85,
                                  ),
                                  Center(
                                    child: Container(
                                      height: 100,
                                      width: 85,
                                      padding: const EdgeInsets.only(left: 1, top: 50, right: 1),
                                      child: Center(
                                        child: Text(
                                          "${category[index]?.name}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                        },
                    ),
                  ),
                );
                },
              ),
              SizedBox(height: 10),
              FutureBuilder<List<ProductModel?>?>(
                  future: productController.getProduct(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        // if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      // } else
                      default:
                        if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Center(
                            child: Column(
                              children: [
                                Text('No Product Found'),
                                // Text('Error: ${snapshot.error}'),
                              ],
                            ),
                          );
                        } else {
                          List<ProductModel?> data = snapshot.data ?? [];
                          return SizedBox(
                            height: 500,
                            child: StaggeredGridView.countBuilder(
                                padding: EdgeInsets.all(0),
                                crossAxisCount: 2,
                                itemCount: data.length,
                                crossAxisSpacing: 10,
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                mainAxisSpacing: 0.0,
                                itemBuilder: (context, index) {
                                  final datas = snapshot.data?.elementAt(index);
                                  print(datas);
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // productController.selectProd = datas;
                                        Get.to(() => ProductDetails());
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => ProductDetails()));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey.shade100,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 120,
                                                width: 200,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: Image.asset(
                                                      'assets/images/moto.png',
                                                      height: 120,
                                                      width: 200,
                                                      fit: BoxFit.fill
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 10, bottom: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                  data[index]?.nameProd ?? 'no name',
                                                          style: TextStyle(
                                                            color: Color(0xFF808080),
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14
                                                          )),
                                                      SizedBox(height: 3),
                                                      Text(
                                                          currencyE.format(data[index]?.price),
                                                          // "553 500  FCFA",
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 14,
                                                          )),
                                                      // SizedBox(height: 3),
                                                      // Row(
                                                      //   mainAxisAlignment:
                                                      //   MainAxisAlignment.spaceEvenly,
                                                      //   children: [
                                                      //     Text("Disponible",
                                                      //       style: TextStyle(
                                                      //           color: Color(0xFF034A8F),
                                                      //           fontWeight: FontWeight.w400,
                                                      //           fontSize: 10,
                                                      //           fontStyle: FontStyle.italic
                                                      //       ),
                                                      //     ),
                                                      //     // InkWell(
                                                      //     //   onTap: () {
                                                      //     //     // showDialog(
                                                      //     //     //     context: context,
                                                      //     //     //     builder: (context) =>
                                                      //     //     //         HelperFunctions()
                                                      //     //     //             .myAlertDialog(
                                                      //     //     //           context: context,
                                                      //     //     //         ));
                                                      //     //   },
                                                      //     //   child: CircleAvatar(
                                                      //     //     radius: 16,
                                                      //     //     backgroundColor: Color(0xFF009FE3),
                                                      //     //     child: Icon(
                                                      //     //       Icons
                                                      //     //           .add,
                                                      //     //       size: 25,
                                                      //     //       color: Colors.white,
                                                      //     //     ),
                                                      //     //   ),
                                                      //     // ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );

                                },
                                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                              ),

                          );
                        }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchBar() {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        prefixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(
            Icons.search,
          ),
        ),
        hintText: 'Search product ...', //8AA0BC
        suffixIcon: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Icon(
            Icons.tune,
          ),
        ),
      ),
    );
  }



}
