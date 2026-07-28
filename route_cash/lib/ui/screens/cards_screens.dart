import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height:10),
            const Icon(Icons.apple,color:Colors.white,size:25),
            const SizedBox(height:12),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                _tab("Cuentas",true),
                const SizedBox(width:20),
                _tab("Transacciones",false),
              ],
            ),
            const SizedBox(height:25),
            Expanded(
              child:SingleChildScrollView(
                padding:const EdgeInsets.symmetric(horizontal:10),
                child:Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children:[
                    _title("CUENTAS DE DEPÓSITO"),
                    const SizedBox(height:12),
                    _card("assets/cards/banco_azul.png","CUENTA CORRIENTE","7841","\$485.230"),
                    _card("assets/cards/scotiabank.png","CUENTA CORRIENTE","3192","\$120.760"),
                    const SizedBox(height:25),
                    _title("TARJETAS DE CRÉDITO"),
                    const SizedBox(height:12),
                    _card("assets/cards/worldmember.png","WORLD MEMBER","8901","\$680.000"),
                    _card("assets/cards/cmr.png","CMR FALABELLA","5523","\$1.240.000"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String text,bool active){
    return Container(
      padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
      decoration:BoxDecoration(
        color:active?const Color(0xFF8B42FF):Colors.transparent,
        borderRadius:BorderRadius.circular(10),
      ),
      child:Text(
        text,
        style:TextStyle(
          color:active?Colors.white:Colors.grey,
          fontSize:11,
          fontWeight:FontWeight.w600,
        ),
      ),
    );
  }

  Widget _title(String text){
    return Text(
      text,
      style:const TextStyle(
        color:Color(0xFF777777),
        fontSize:10,
        fontWeight:FontWeight.w600,
      ),
    );
  }

  Widget _card(String image,String title,String number,String balance){
    return Container(
      margin:const EdgeInsets.only(bottom:12),
      child:Row(
        children:[
          ClipRRect(
            borderRadius:BorderRadius.circular(5),
            child:Image.asset(
              image,
              width:85,
              height:55,
              fit:BoxFit.cover,
            ),
          ),
          const SizedBox(width:14),
          Expanded(
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children:[
                Text(
                  title,
                  style:const TextStyle(
                    color:Colors.white,
                    fontSize:10,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                Text(
                  number,
                  style:const TextStyle(
                    color:Color(0xFF888888),
                    fontSize:9,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment:CrossAxisAlignment.end,
            children:[
              const Text(
                "DISPONIBLE",
                style:TextStyle(
                  color:Color(0xFF777777),
                  fontSize:8,
                ),
              ),
              Text(
                balance,
                style:const TextStyle(
                  color:Colors.white,
                  fontSize:12,
                  fontWeight:FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}