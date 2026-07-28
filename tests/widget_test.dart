import 'package:flutter_test/flutter_test.dart';
import 'package:the_code_cup/main.dart';
import 'package:the_code_cup/viewmodels/home_viewmodel.dart';

void main() {
  testWidgets('app renders home screen', (WidgetTester tester) async {
    final viewModel = HomeViewModel();
    await tester.pumpWidget(MyApp(homeViewModel: viewModel));
    expect(find.text('The Code Cup'), findsOneWidget);
  });
}
