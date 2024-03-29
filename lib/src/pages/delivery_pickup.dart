import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/DeliveryAddressesItemWidget.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;
  PaymentMethodList list;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).checkout,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            /*Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.domain,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).pickup,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).pickup_your_product_from_the_market,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),*/
            /*ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: list.pickupList.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return PaymentMethodListItemWidget(paymentMethod: list.pickupList.elementAt(index));
              },
            ),*/
            _con.carts.isNotEmpty
                ? Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.person, color: Theme.of(context).hintColor)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(color: Theme.of(context).hintColor),
                                keyboardType: TextInputType.text,
                                decoration: getInputDecoration(context,
                                    hintText: S.of(context).hint_name,
                                    labelText: S.of(context).full_name),
                                initialValue: _con.name,
                                onChanged: (value) {
                                  _con.setName(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                            children: [
                              Container(margin: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.phone, color: Theme.of(context).hintColor)),
                              Expanded(
                                flex: 9,
                                child: TextFormField(
                                  style: TextStyle(color: Theme.of(context).hintColor),
                                  keyboardType: TextInputType.phone,
                                  decoration: getInputDecoration(context, hintText: S.of(context).hint_phone, labelText: S.of(context).phone),
                                  initialValue: _con.phone,
                                  onChanged: (value) {
                                    _con.setPhone(value);
                                  },
                                ),
                              ),
                            ]
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.map,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            S.of(context).delivery,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            S.of(context).click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      DeliveryAddressesItemWidget(
                        address: _con.deliveryAddress,
                        text: _con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null'
                            ? S.of(context).input_delivery_address : _con.deliveryAddress.address,
                        onPressed: (Address _address) {
                          // if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null') {
                            DeliveryAddressDialog(
                              context: context,
                              address: _address,
                              onChanged: (Address _address) {
                                _con.addAddress(_address);
                              },
                            );
                          // } else {
                            // Navigator.of(context).pushNamed('/PaymentMethod');
                          // }
                        },
                        onLongPress: (Address _address) {
                          DeliveryAddressDialog(
                            context: context,
                            address: _address,
                            onChanged: (Address _address) {
                              _con.updateAddress(_address);
                            },
                          );
                        },
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                            if ( _con.name.isNotEmpty && _con.phone.isNotEmpty
                                && !(_con.deliveryAddress.id == null
                                    || _con.deliveryAddress.id == 'null') ) {
                              Navigator.of(context).pushNamed('/PayOnPickup');
                            }
                          },
                          disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color:
                          !_con.carts[0].food.restaurant.closed ? Theme.of(context).accentColor : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            S.of(context).send_order,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
