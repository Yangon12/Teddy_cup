USE luoyang;
DROP TABLE meber_info;
CREATE TABLE meber_info/*创建人员信息表*/
(
    userid BIGINT(20) PRIMARY KEY COMMENT '人员ID',
    openid VARCHAR(64) NOT NULL COMMENT '微信OpenID',
    gender VARCHAR(2) NOT NULL COMMENT '性别',
    nation VARCHAR(20) NOT NULL COMMENT '民族',
    age INT NOT NULL COMMENT '年龄',
    birthdate VARCHAR(20) NOT NULL COMMENT '出生日期',
    create_time TIMESTAMP NOT NULL COMMENT '创建时间'
);
DROP TABLE position_info;
CREATE TABLE position_info/*创建场所信息表*/
(
    grid_point_id BIGINT(20) PRIMARY KEY COMMENT '场所ID',
    pname VARCHAR(255) NOT NULL COMMENT '场所名',
    point_type VARCHAR(50) COMMENT '场所类型',
    x_coordinate DECIMAL(12,2) NOT NULL COMMENT 'X坐标（单位：米）',
    y_coordinate DECIMAL(12,2) NOT NULL COMMENT 'Y坐标（单位：米）',
    create_time TIMESTAMP NOT NULL COMMENT '创建时间'
);
DROP TABLE SELFsearching_info;
CREATE TABLE SELFsearching_info/*创建个人自查上报信息表*/
(
    sno BIGINT(20) PRIMARY KEY COMMENT '序列号：自查记录唯一标识',
    userid BIGINT(20) COMMENT '人员ID：对应于“人员信息表中的userid”',
    Foreign Key (userid) REFERENCES meber_info(userid),
    x_coordinate DECIMAL(12,2) NOT NULL COMMENT '上报地点的X坐标',
    y_coordinate DECIMAL(12,2) NOT NULL COMMENT '上报地点的Y坐标',
    symptom VARCHAR(100) NOT NULL COMMENT '症状：1发热 2乏力 3干咳 4鼻塞 5流涕 6腹泻 7呼吸困难 8无症状',
    nucleic_acid_result VARCHAR(10) NOT NULL COMMENT '核酸检测结果：0阴性 1阳性 2未知（非必填）',
    resident_flag INT NOT NULL COMMENT '是否是常住居民：0未知 1是 2否',
    dump_time TIMESTAMP NOT NULL COMMENT '上报时间'
);
DROP TABLE place_code_scanning_info;
CREATE TABLE place_code_scanning_info/*创建场所码扫码信息表*/
(
    sno BIGINT(20) PRIMARY KEY COMMENT '系列号：扫码记录唯一标识',
    grid_point_id BIGINT(20) COMMENT '场所ID：对应于“场所信息表中的grid_point_id”',
    Foreign Key (grid_point_id) REFERENCES position_info(grid_point_id),
    userid BIGINT(20) COMMENT '人员ID：对应于“人员信息表中的userid”',
    Foreign Key (userid) REFERENCES meber_info(userid),
    temperature DOUBLE NOT NULL COMMENT '体温',
    create_time TIMESTAMP NOT NULL COMMENT '扫码记录时间'
);
DROP TABLE NA_Sampling_Detection;
CREATE TABLE NA_Sampling_Detection
(
    sno BIGINT(20) PRIMARY KEY COMMENT '系列号：核酸采样记录唯一标识',
    userid BIGINT(20) NOT NULL COMMENT '人员ID：对应于“人员信息表中的userid”',
    Foreign Key (userid) REFERENCES meber_info(userid),
    cysj TIMESTAMP NOT NULL COMMENT '采样日期和时间',
    jcsj TIMESTAMP NOT NULL COMMENT '检测日期和时间',
    jg VARCHAR(50) NOT NULL COMMENT '检测结果：阴性、阳性、未知',
    grid_point_id BIGINT(20) COMMENT '场所ID：对应于“场所信息表中的grid_point_id”',
    Foreign Key (grid_point_id) REFERENCES position_info(grid_point_id)
);
DROP TABLE Vaccination_record;
CREATE TABLE Vaccination_record
(
    sno BIGINT(20) PRIMARY KEY COMMENT '系列号：疫苗接种记录唯一标识',
    inject_sn VARCHAR(50) COMMENT '接种流水号',
    userid BIGINT(20) COMMENT '人员ID：对应于“人员信息表中的userid”',
    Foreign Key (userid) REFERENCES meber_info(userid),
    age INT NOT NULL COMMENT '接种者年龄',
    gender VARCHAR(10) NOT NULL COMMENT '性别：1男 2女',
    birthdate VARCHAR(50) NOT NULL COMMENT '出生日期',
    inject_date TIMESTAMP NOT NULL COMMENT '接种日期',
    inject_times VARCHAR(30) NOT NULL COMMENT '针次：1第一针 2第二针 3加强针',
    vaccine_type VARCHAR(30) NOT NULL COMMENT '疫苗类型：1灭活疫苗 2重组蛋白疫苗 3病毒载体疫苗 4核酸疫苗 5减毒疫苗'
);
SELECT * INTO OUTFILE 'E:\Tedy_cup\TABLE/data1.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM meber_info;