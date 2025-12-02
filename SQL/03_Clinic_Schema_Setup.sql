

DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinics;
DROP TABLE IF EXISTS customer;

CREATE TABLE clinics (
  cid          VARCHAR(64) PRIMARY KEY,
  clinic_name  VARCHAR(200) NOT NULL,
  city         VARCHAR(120),
  state        VARCHAR(120),
  country      VARCHAR(120)
);

CREATE TABLE customer (
  uid     VARCHAR(64) PRIMARY KEY,
  name    VARCHAR(120) NOT NULL,
  mobile  VARCHAR(40)
);

CREATE TABLE clinic_sales (
  oid           VARCHAR(64) PRIMARY KEY,
  uid           VARCHAR(64) NOT NULL REFERENCES customer(uid),
  cid           VARCHAR(64) NOT NULL REFERENCES clinics(cid),
  amount        DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
  "datetime"    TIMESTAMP     NOT NULL,
  sales_channel VARCHAR(60)   NOT NULL
);

CREATE TABLE expenses (
  eid        VARCHAR(64) PRIMARY KEY,
  cid        VARCHAR(64) NOT NULL REFERENCES clinics(cid),
  description VARCHAR(200),
  amount     DECIMAL(12,2) NOT NULL CHECK (amount >= 0),
  "datetime" TIMESTAMP     NOT NULL
);

CREATE INDEX idx_sales_date   ON clinic_sales("datetime");
CREATE INDEX idx_sales_cid    ON clinic_sales(cid);
CREATE INDEX idx_sales_chan   ON clinic_sales(sales_channel);
CREATE INDEX idx_exp_date     ON expenses("datetime");
CREATE INDEX idx_exp_cid      ON expenses(cid);

INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001','XYZ clinic','lorem','ipsum','dolor');

INSERT INTO customer (uid, name, mobile) VALUES
('bk-09f3e-95hj','Jon Doe','97XXXXXXXX');

INSERT INTO clinic_sales (oid, uid, cid, amount, "datetime", sales_channel) VALUES
('ord-00100-00100','bk-09f3e-95hj','cnc-0100001',24999,'2021-09-23 12:03:22','sodat');

INSERT INTO expenses (eid, cid, description, amount, "datetime") VALUES
('exp-0100-00100','cnc-0100001','first-aid supplies',557,'2021-09-23 07:36:48');
