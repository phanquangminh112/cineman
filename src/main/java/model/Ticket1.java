package model;

import java.math.BigDecimal;

public class Ticket1 {
    private int id;
    private BigDecimal price;
    private String status;
    private Showtime1 showtime;
    private ScreeningRoomSeat1 seat;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Showtime1 getShowtime() {
        return showtime;
    }

    public void setShowtime(Showtime1 showtime) {
        this.showtime = showtime;
    }

    public ScreeningRoomSeat1 getSeat() {
        return seat;
    }

    public void setSeat(ScreeningRoomSeat1 seat) {
        this.seat = seat;
    }
}
