import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;

  MenuWidget({Key key, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  RestaurantController _con;

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForFoods(widget.routeArgument.id);
    _con.listenForTrendingFoods(widget.routeArgument.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _con.foods.isNotEmpty ? _con.foods[0].restaurant.name : '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.trending_up,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).trending_this_week,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).double_click_on_the_product_to_add_it_to_the,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
              ),
            ),
            FoodsCarouselWidget(heroTag: 'menu_trending_food', foodsList: _con.trendingFoods),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.list,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).all_product,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).longpress_on_the_product_to_add_suplements,
                style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 11)),
              ),
            ),
            _con.foods.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.foods.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return FoodItemWidget(
                        heroTag: 'menu_list',
                        food: _con.foods.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

}
