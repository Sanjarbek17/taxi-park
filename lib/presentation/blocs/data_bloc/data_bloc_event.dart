part of 'data_bloc.dart';

sealed class DataBlocEvent extends Equatable {
  const DataBlocEvent();

  @override
  List<Object> get props => [];
}

final class OrdersSubscriptionRequested extends DataBlocEvent {
  const OrdersSubscriptionRequested();
}

final class DriversSubscriptionRequested extends DataBlocEvent {
  const DriversSubscriptionRequested();
}

final class AddressesSubscriptionRequested extends DataBlocEvent {
  const AddressesSubscriptionRequested();
}

final class DriversSearchRequested extends DataBlocEvent {
  final String query;

  const DriversSearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

final class PickedDateOrdersRange extends DataBlocEvent {
  final DateTime startDate;
  final DateTime endDate;

  const PickedDateOrdersRange(this.startDate, this.endDate);
}
