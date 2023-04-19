import 'package:expense_tracker/Helper/Database/double_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountListTile extends StatelessWidget {
  final Account account;
  final double balance;

  const AccountListTile({
    super.key,
    required this.account,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AccountDetailPage.routeName,
        arguments: account,
      ),
      child: Container(
        width: 145,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: account.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (account.iconPath != null)
                  SizedBox(
                    height: 14,
                    width: 14,
                    child: SvgPicture.asset(
                      account.iconPath!,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    account.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 15,
                )
              ],
            ),
            //   const Spacer(),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        '${balance.toStringAsFixedRounded(2)}€',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
