package model;

import java.time.LocalDate;

public class CustomerStatistic1 {
    private int id;
    private int totalCustomers;
    private int newMembers;
    private LocalDate statPeriodBegin;
    private LocalDate statPeriodEnd;

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getNewMembers() {
        return newMembers;
    }

    public void setNewMembers(int newMembers) {
        this.newMembers = newMembers;
    }

    public LocalDate getStatPeriodBegin() {
        return statPeriodBegin;
    }

    public void setStatPeriodBegin(LocalDate statPeriodBegin) {
        this.statPeriodBegin = statPeriodBegin;
    }

    public LocalDate getStatPeriodEnd() {
        return statPeriodEnd;
    }

    public void setStatPeriodEnd(LocalDate statPeriodEnd) {
        this.statPeriodEnd = statPeriodEnd;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
