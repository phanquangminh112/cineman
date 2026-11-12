package model;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Bill1 {
    private int id;
    private LocalDateTime billDate;
    private BigDecimal totalAmount;
    private Customer1 customer;
    private TicketSeller1 seller;
    private Ticket1[] tickets;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getBillDate() {
        return billDate;
    }

    public void setBillDate(LocalDateTime billDate) {
        this.billDate = billDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Customer1 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer1 customer) {
        this.customer = customer;
    }

    public TicketSeller1 getSeller() {
        return seller;
    }

    public void setSeller(TicketSeller1 seller) {
        this.seller = seller;
    }

    public Ticket1[] getTickets() {
        return tickets;
    }

    public void setTickets(Ticket1[] tickets) {
        this.tickets = tickets;
    }
}
