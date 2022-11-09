// import 'package:flutter/material.dart';
// import 'package:settings/base/base_view.dart';
// import 'package:settings/tracking-drinkwater/controllers/tracking_drinkwater_controller.dart';
// import 'package:settings/tracking-drinkwater/models/chart_data.dart';
// import 'package:settings/utils/Color.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../resources/data_constant.dart';

// class AnalyticsWidget extends BaseView<TrackingDrinkwaterController> {
//   @override
//   Widget buildView(BuildContext context) {
//     final List<ChartDataa> chartData = [
//       ChartDataa(1, 100),
//       ChartDataa(2, 150),
//       ChartDataa(3, 300),
//       ChartDataa(4, 1000),
//       ChartDataa(5, 500)
//     ];
//     return Scaffold(
//       backgroundColor: Colur.unselected_star,
//       appBar: AppBar(
//         backgroundColor: Colur.unselected_star,
//         title: const Text("Tổng quan"),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               SizedBox(
//                 height: 40,
//               ),
//               Text(
//                 "Tổng lượng nước bạn uống trong tuần",
//                 style:
//                     TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           SfCartesianChart(
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             plotAreaBorderWidth: 0,
//             primaryXAxis: CategoryAxis(
//               axisLine: const AxisLine(width: 0),
//               isVisible: true,
//               majorGridLines: const MajorGridLines(width: 0),
//               majorTickLines: const MajorTickLines(size: 0),
//             ),
//             primaryYAxis: NumericAxis(
//               axisLine: const AxisLine(width: 0),
//               isVisible: false,
//             ),
//             series: [
//               ColumnSeries(
//                 animationDuration: 0,
//                 isTrackVisible: true,
//                 trackColor: Palette.lighterBlue.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(4),
//                 dataLabelSettings: const DataLabelSettings(
//                   isVisible: true,
//                   showZeroValue: false,
//                   textStyle: TextStyle(
//                     color: Palette.foregroundColor,
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   labelAlignment: ChartDataLabelAlignment.outer,
//                 ),
//                 dataSource: controller.generateChartDatasweak(),
//                 xValueMapper: (ChartData? data, _) => data?.label,
//                 yValueMapper: (ChartData? data, _) =>
//                     data!.record!.totalCapacity,
//               )
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               SizedBox(
//                 height: 40,
//               ),
//               Text(
//                 "Tổng lượng nước bạn uống theo tháng",
//                 style:
//                     TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           SfCartesianChart(series: <ChartSeries<ChartDataa, int>>[
//             ColumnSeries<ChartDataa, int>(
//                 dataSource: chartData,
//                 xValueMapper: (ChartDataa data, _) => data.x,
//                 yValueMapper: (ChartDataa data, _) => data.y,
//                 // Width of the columns
//                 width: 0.8,
//                 // Spacing between the columns
//                 spacing: 0.2)
//           ])
//         ],
//       ),
//     );
//   }
// }
