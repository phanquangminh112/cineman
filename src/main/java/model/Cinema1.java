package model;

public class Cinema1 {
    private int id;
    private String name;
    private String address;
    private String description;
    private ScreeningRoom1[] screeningRooms;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ScreeningRoom1[] getScreeningRooms() {
        return screeningRooms;
    }

    public void setScreeningRooms(ScreeningRoom1[] screeningRooms) {
        this.screeningRooms = screeningRooms;
    }
}
