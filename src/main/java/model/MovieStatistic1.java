package model;

public class MovieStatistic1 {
    private Movie1 movie;
    private int totalShowtimes;
    private int actualTicketsSold;

    public int getTotalShowtimes() {
        return totalShowtimes;
    }

    public void setTotalShowtimes(int totalShowtimes) {
        this.totalShowtimes = totalShowtimes;
    }

    public int getActualTicketsSold() {
        return actualTicketsSold;
    }

    public void setActualTicketsSold(int actualTicketsSold) {
        this.actualTicketsSold = actualTicketsSold;
    }

    public Movie1 getMovie() {
        return movie;
    }

    public void setMovie(Movie1 movie) {
        this.movie = movie;
    }
}
