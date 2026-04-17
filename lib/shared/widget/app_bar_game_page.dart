import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:progress/shared/widget/day_counter_coin.dart';
import 'package:progress/shared/widget/hearts_for_live.dart';

class AppBarGamePage extends StatelessWidget {
   final int tryS ;
   final int daysCompleted;
   final VoidCallback onTapForLanguage;
   final VoidCallback? onTapForDay;
   final VoidCallback onTapForLive;
  const AppBarGamePage({super.key, required this.tryS,  required this.daysCompleted,required this.onTapForLanguage, required this.onTapForLive, required this.onTapForDay,} );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 20,top: 25,left: 20,bottom: 10,),
          child: Row(
            children: [
              // Expanded(child: GestureDetector(
              //   onTap: onTapForLanguage,
              //   child: CountryFlag.fromCountryCode(
              //     'US',
              //     theme: const ImageTheme( width: 20,height: 30,shape: RoundedRectangle(5)),
              //   ),
              // ),),
              // Expanded( flex: 7,child: GestureDetector( onTap: onTapForDay,child: Center(child: DayCounterCoin(value: daysCompleted,size: 30,)))),
              Expanded( flex: 1,child: GestureDetector(onTap: onTapForLive ,child: HeartsForLive(tryS: tryS,))),
              SizedBox(width: 10,),
            ],
          ),
        ),
    );
  }
}
