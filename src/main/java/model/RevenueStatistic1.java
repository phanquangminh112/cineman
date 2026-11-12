package model;
import java.time.LocalDate;

public class RevenueStatistic1 {
    private int id;
    private LocalDate statPeriodBegin;
    private LocalDate statPeriodEnd;
    private double totalRevenue;

    public LocalDate getStatPeriodBegin() {
        return statPeriodBegin;
    }

    public void setStatPeriodBegin(LocalDate statPeriodBegin) {
        this.statPeriodBegin = statPeriodBegin;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getStatPeriodEnd() {
        return statPeriodEnd;
    }

    public void setStatPeriodEnd(LocalDate statPeriodEnd) {
        this.statPeriodEnd = statPeriodEnd;
    }
}
