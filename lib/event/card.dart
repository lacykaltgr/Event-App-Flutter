import 'package:flutter/material.dart';
import '../pages/pages.dart';

Positioned activeCard(
  Event event,
  List timelineEventIds,
  List answeredEventIds,
  BuildContext context,
  Function dismissEvent,
  Function addEvent,
) {
  Size screenSize = MediaQuery.of(context).size;
  return Positioned(
      bottom: 0,
      right: null,
      left: null,
      width: screenSize.width,
      height: screenSize.height * 0.87,
      child: Dismissible(
        key: UniqueKey(),
        crossAxisEndOffset: 0.05,
        onDismissed: (DismissDirection direction) {
          answeredEventIds.add(event.eventId);
          if (direction == DismissDirection.endToStart) {
            dismissEvent(timelineEventIds, event);
          } else {
            addEvent(timelineEventIds, event);
          }
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(60), topRight: Radius.circular(60)),
          child: CardDetail(
            event: event,
            addEvent: addEvent,
            dismissEvent: dismissEvent,
            timelineEventIds: timelineEventIds,
          ),
        ),
      ));
}
