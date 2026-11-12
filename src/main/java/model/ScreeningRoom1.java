package model;

public class ScreeningRoom1 {
    private int id;
    private String roomName;
    private String description;
    private int capacity;
    private ScreeningRoomSeat1[] seats;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public ScreeningRoomSeat1[] getSeats() {
        return seats;
    }

    public void setSeats(ScreeningRoomSeat1[] seats) {
        this.seats = seats;
    }
}
