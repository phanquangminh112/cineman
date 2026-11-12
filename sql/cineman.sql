DROP DATABASE IF EXISTS cineman;
CREATE DATABASE cineman CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cineman;

CREATE TABLE user1 (
    username      VARCHAR(50)  PRIMARY KEY,
    password      VARCHAR(100) NOT NULL,
    name          VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email         VARCHAR(100),
    phone         VARCHAR(20),
    address       VARCHAR(200)
);

CREATE TABLE customer1 (
    username       VARCHAR(50) PRIMARY KEY,
    loyalty_points INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_customer_user FOREIGN KEY (username) REFERENCES user1 (username)
);

CREATE TABLE employee1 (
    username VARCHAR(50) PRIMARY KEY,
    position VARCHAR(50) NOT NULL,
    CONSTRAINT fk_employee_user FOREIGN KEY (username) REFERENCES user1 (username)
);

CREATE TABLE cinema1 (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    address     VARCHAR(200),
    description VARCHAR(255)
);

CREATE TABLE screening_room1 (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    cinema_id   INT NOT NULL,
    room_name   VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    capacity    INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_room_cinema FOREIGN KEY (cinema_id) REFERENCES cinema1 (id)
);

CREATE TABLE seat1 (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    `row`   INT NOT NULL,
    `column` INT NOT NULL,
    type    VARCHAR(30) NOT NULL DEFAULT 'Thường',
    CONSTRAINT fk_seat_room FOREIGN KEY (room_id) REFERENCES screening_room1 (id)
);

CREATE TABLE movie1 (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    genre         VARCHAR(50),
    director      VARCHAR(100),
    main_actors   VARCHAR(200),
    duration      INT,
    description   TEXT,
    image_url     VARCHAR(255),
    released_date DATE,
    status        VARCHAR(20) NOT NULL DEFAULT 'Đang chiếu'
);

CREATE TABLE showtime1 (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    movie_id   INT NOT NULL,
    room_id    INT NOT NULL,
    show_date  DATE NOT NULL,
    start_time TIME NOT NULL,
    time_end   TIME NOT NULL,
    CONSTRAINT fk_show_movie FOREIGN KEY (movie_id) REFERENCES movie1 (id),
    CONSTRAINT fk_show_room  FOREIGN KEY (room_id)  REFERENCES screening_room1 (id)
);

CREATE TABLE screening_room_seat1 (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id INT NOT NULL,
    seat_id     INT NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'Còn trống',
    CONSTRAINT fk_srs_showtime FOREIGN KEY (showtime_id) REFERENCES showtime1 (id) ON DELETE CASCADE,
    CONSTRAINT fk_srs_seat     FOREIGN KEY (seat_id)     REFERENCES seat1 (id),
    CONSTRAINT uq_srs UNIQUE (showtime_id, seat_id)
);

CREATE TABLE bill1 (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    bill_date         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount      DOUBLE NOT NULL DEFAULT 0,
    customer_username VARCHAR(50),
    seller_username   VARCHAR(50),
    CONSTRAINT fk_bill_customer FOREIGN KEY (customer_username) REFERENCES customer1 (username),
    CONSTRAINT fk_bill_seller   FOREIGN KEY (seller_username)   REFERENCES employee1 (username)
);

CREATE TABLE ticket1 (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    showtime_id INT NOT NULL,
    srs_id      INT NOT NULL,
    price       DOUBLE NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'Đã bán',
    bill_id     INT,
    CONSTRAINT fk_ticket_show FOREIGN KEY (showtime_id) REFERENCES showtime1 (id),
    CONSTRAINT fk_ticket_srs  FOREIGN KEY (srs_id)      REFERENCES screening_room_seat1 (id),
    CONSTRAINT fk_ticket_bill FOREIGN KEY (bill_id)     REFERENCES bill1 (id)
);

CREATE TABLE membership_card1 (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    issue_date        DATE NOT NULL,
    customer_username VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT fk_card_customer FOREIGN KEY (customer_username) REFERENCES customer1 (username)
);

INSERT INTO user1 (username, password, name, date_of_birth, email, phone, address) VALUES
('manager1',  '123', 'Nguyễn Văn An', '1990-04-12', 'an@cineman.vn',     '0901123456', 'Quận 1, TP. Hồ Chí Minh'),
('seller1',   '123', 'Trần Thị Bích', '1996-08-25', 'bich@cineman.vn',   '0902567890', 'Quận 3, TP. Hồ Chí Minh'),
('customer1', '123', 'Lê Văn Cường',  '2001-01-30', 'cuong@example.com', '0353456789', 'TP. Thủ Đức, TP. Hồ Chí Minh');

INSERT INTO employee1 (username, position) VALUES
('manager1', 'Quản lí'),
('seller1',  'Nhân viên bán hàng');

INSERT INTO customer1 (username, loyalty_points) VALUES
('customer1', 190);

INSERT INTO membership_card1 (issue_date, customer_username) VALUES
('2025-05-01', 'customer1');

INSERT INTO cinema1 (name, address, description) VALUES
('Rạp CineMan', '01 Đại lộ Võ Văn Kiệt, Quận 1, TP. Hồ Chí Minh', 'Rạp chiếu phim CineMan gồm nhiều phòng chiếu hiện đại');

INSERT INTO screening_room1 (cinema_id, room_name, description, capacity) VALUES
(1, 'Phòng 1', 'Phòng chiếu 2D', 40),
(1, 'Phòng 2', 'Phòng chiếu 2D', 40),
(1, 'Phòng 3', 'Phòng chiếu 3D', 40);

INSERT INTO seat1 (room_id, `row`, `column`, type)
SELECT r.id, rw.rw, sc.cl, 'Thường'
FROM screening_room1 r
CROSS JOIN (SELECT 1 AS rw UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) rw
CROSS JOIN (SELECT 1 AS cl UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
            UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8) sc;

INSERT INTO movie1 (id, title, genre, director, main_actors, duration, description, image_url, released_date, status) VALUES
(12, 'Người vợ ba', 'Tâm lý', 'Ash Mayfair', 'Nguyễn Phương Trà My, Long Lê', 115,
 'Câu chuyện về người vợ ba trong một gia đình miền Bắc những năm thập niên 1930 (dữ liệu mẫu minh họa).',
 'nguoi-vo-ba.svg', '2025-05-15', 'Đang chiếu'),
(18, 'Người nhện: Dạ hành', 'Hành động', 'Joaquim Dos Santos, Kemp Powers, Justin K. Thompson', 'Shameik Moore, Hailee Steinfeld', 140,
 'Phim hoạt hình siêu anh hùng về Người nhện đa vũ trụ (dữ liệu mẫu minh họa).',
 'nguoi-nhen-da-hanh.svg', '2025-06-06', 'Đang chiếu'),
(23, 'Người sắt', 'Hành động', 'Jon Favreau', 'Robert Downey Jr., Gwyneth Paltrow', 126,
 'Phim siêu anh hùng về Tony Stark và bộ giáp thép (dữ liệu mẫu minh họa).',
 'nguoi-sat.svg', '2025-07-01', 'Sắp chiếu'),
(25, 'Godzilla x Kong: Đế chế mới', 'Hành động', 'Adam Wingard', 'Rebecca Hall, Brian Tyree Henry, Dan Stevens', 115,
 'Hai titans huyền thoại cùng đối mặt một mối đe dọa chưa từng có (dữ liệu mẫu minh họa).',
 'godzilla-kong.svg', '2025-03-29', 'Đang chiếu');

INSERT INTO showtime1 (movie_id, room_id, show_date, start_time, time_end) VALUES
(12, 1, CURDATE(),                           '09:00:00', '11:00:00'),
(12, 2, CURDATE(),                           '14:00:00', '16:00:00'),
(12, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '18:00:00', '20:00:00'),
(18, 2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00', '11:00:00'),
(25, 1, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '18:00:00', '20:00:00'),
(25, 3, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '09:00:00', '11:00:00');

INSERT INTO screening_room_seat1 (showtime_id, seat_id, status)
SELECT s.id, se.id, 'Còn trống'
FROM showtime1 s
JOIN seat1 se ON se.room_id = s.room_id;

INSERT INTO bill1 (bill_date, total_amount, customer_username, seller_username) VALUES
(NOW(), 190000, 'customer1', 'seller1');

INSERT INTO ticket1 (showtime_id, srs_id, price, status, bill_id)
SELECT s.id, srs.id, 95000, 'Đã bán', 1
FROM showtime1 s
JOIN screening_room_seat1 srs ON srs.showtime_id = s.id
WHERE s.movie_id = 12 AND s.room_id = 1
ORDER BY srs.id
LIMIT 2;

UPDATE screening_room_seat1
SET status = 'Đã đặt'
WHERE id IN (SELECT srs_id FROM ticket1);

CREATE OR REPLACE VIEW movie_statistic1 AS
SELECT m.id AS movie_id,
       m.title AS movie_title,
       COUNT(DISTINCT s.id)  AS total_showtimes,
       COUNT(t.id)           AS actual_tickets_sold
FROM movie1 m
LEFT JOIN showtime1 s ON s.movie_id = m.id
LEFT JOIN ticket1 t   ON t.showtime_id = s.id
GROUP BY m.id, m.title;

CREATE OR REPLACE VIEW customer_statistic1 AS
SELECT (SELECT COUNT(*) FROM customer1) AS total_customers,
       (SELECT COUNT(*)
        FROM customer1 c2
        JOIN membership_card1 mc ON mc.customer_username = c2.username
        WHERE mc.issue_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) AS new_members;

CREATE OR REPLACE VIEW revenue_statistic1 AS
SELECT s.show_date AS stat_period_begin,
       COALESCE(SUM(t.price), 0) AS total_revenue
FROM showtime1 s
LEFT JOIN ticket1 t ON t.showtime_id = s.id
GROUP BY s.show_date;
