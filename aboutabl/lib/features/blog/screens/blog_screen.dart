import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/blog/widgets/blog_grid_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

import '../controllers/blog_controller.dart';

class BlogScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const BlogScreen({super.key, this.isBackButtonExist = true});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Provider.of<BlogController>(context, listen: false).getBlogs(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (val, _) async {
        if (Navigator.of(context).canPop()) {
          return;
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const DashBoardScreen()));
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: getTranslated('blog', context),
            isBackButtonExist: widget.isBackButtonExist,
            onBackPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const DashBoardScreen()));
              }
            }),
        body: const BlogGridWidget(),
      ),
    );
  }
}
