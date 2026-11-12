package model;
import java.time.LocalDate;
import java.time.LocalTime;

public class Showtime1 {
    private int id;
    private LocalDate showDate;
    private LocalTime timeStart;
    private LocalTime timeEnd;
    private Movie1 movie;
    private ScreeningRoom1 screeningRoom;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getShowDate() {
        return showDate;
    }

    public void setShowDate(LocalDate showDate) {
        this.showDate = showDate;
    }

    public LocalTime getTimeStart() {
        return timeStart;
    }

    public void setTimeStart(LocalTime timeStart) {
        this.timeStart = timeStart;
    }

    public LocalTime getTimeEnd() {
        return timeEnd;
    }

    public void setTimeEnd(LocalTime timeEnd) {
        this.timeEnd = timeEnd;
    }

    public Movie1 getMovie() {
        return movie;
    }

    public void setMovie(Movie1 movie) {
        this.movie = movie;
    }

    public ScreeningRoom1 getScreeningRoom() {
        return screeningRoom;
    }

    public void setScreeningRoom(ScreeningRoom1 screeningRoom) {
        this.screeningRoom = screeningRoom;
    }
}
