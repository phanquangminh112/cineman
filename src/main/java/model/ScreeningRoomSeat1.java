package model;

public class ScreeningRoomSeat1 {
    private int id;
    private String status;
    private Seat1 seat;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Seat1 getSeat() {
        return seat;
    }

    public void setSeat(Seat1 seat) {
        this.seat = seat;
    }
}
