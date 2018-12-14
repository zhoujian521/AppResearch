package com.appresearch;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;


public class ZJTopLoadingStartEvent extends Event<ZJTopLoadingStartEvent> {

    public static final String EVENT_NAME = "topLoadingStart";
    private WritableMap mEventData;

    public ZJTopLoadingStartEvent(int viewId, WritableMap eventData) {
        super(viewId);
        mEventData = eventData;
    }

    @Override
    public String getEventName() {
        return EVENT_NAME;
    }

    @Override
    public boolean canCoalesce() {
        return false;
    }

    @Override
    public short getCoalescingKey() {
        // All events for a given view can be coalesced.
        return 0;
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), mEventData);
    }
}
