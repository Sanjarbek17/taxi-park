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