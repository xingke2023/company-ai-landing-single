--
-- PostgreSQL database dump
--

\restrict QQt9iG8Zj77BbfoH43GAHkwbxwWz6xK8wVrHoU0MvTF9pUHZKMoMh4FX85q0Ibc

-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_messages (
    id bigint NOT NULL,
    session_id bigint NOT NULL,
    role smallint NOT NULL,
    input_type smallint DEFAULT '1'::smallint NOT NULL,
    raw_content text,
    voice_url character varying(500),
    image_urls json,
    transcribed_text text,
    ocr_text text,
    ai_response text,
    intent character varying(100),
    entities json,
    confidence numeric(5,4),
    dispatched_module character varying(50),
    dispatched_action_id bigint,
    processing_time_ms integer,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN ai_messages.role; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.role IS '1:用户 2:AI助手';


--
-- Name: COLUMN ai_messages.input_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.input_type IS '1:文字 2:语音 3:图片 4:混合';


--
-- Name: COLUMN ai_messages.raw_content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.raw_content IS '原始文字输入';


--
-- Name: COLUMN ai_messages.transcribed_text; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.transcribed_text IS '语音转文字结果';


--
-- Name: COLUMN ai_messages.ocr_text; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.ocr_text IS '图片OCR结果';


--
-- Name: COLUMN ai_messages.intent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.intent IS '识别的意图类型';


--
-- Name: COLUMN ai_messages.entities; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.entities IS '提取的实体（商品名、数量等）';


--
-- Name: COLUMN ai_messages.confidence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.confidence IS '意图置信度';


--
-- Name: COLUMN ai_messages.dispatched_module; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.dispatched_module IS '分发到的功能模块';


--
-- Name: COLUMN ai_messages.dispatched_action_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_messages.dispatched_action_id IS '触发的业务记录ID';


--
-- Name: ai_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_messages_id_seq OWNED BY public.ai_messages.id;


--
-- Name: ai_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_sessions (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    user_id bigint NOT NULL,
    session_uuid uuid NOT NULL,
    channel smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    started_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ended_at timestamp(0) without time zone,
    context json,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN ai_sessions.channel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_sessions.channel IS '1:APP语音 2:APP文字 3:企业微信 4:Web';


--
-- Name: COLUMN ai_sessions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_sessions.status IS '1:进行中 2:已完成 3:异常';


--
-- Name: COLUMN ai_sessions.context; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ai_sessions.context IS '多轮对话上下文';


--
-- Name: ai_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ai_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_sessions_id_seq OWNED BY public.ai_sessions.id;


--
-- Name: app_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_settings (
    id bigint NOT NULL,
    key character varying(100) NOT NULL,
    value text,
    label character varying(100),
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN app_settings.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_settings.key IS '设置键，如 miniprogram_title';


--
-- Name: COLUMN app_settings.value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_settings.value IS '设置值';


--
-- Name: COLUMN app_settings.label; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_settings.label IS '后台显示的中文说明';


--
-- Name: app_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_settings_id_seq OWNED BY public.app_settings.id;


--
-- Name: attendance_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance_records (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    store_id bigint NOT NULL,
    work_date date NOT NULL,
    scheduled_start time(0) without time zone,
    scheduled_end time(0) without time zone,
    clock_in_at timestamp(0) without time zone,
    clock_out_at timestamp(0) without time zone,
    clock_in_source smallint,
    work_hours numeric(4,2),
    overtime_hours numeric(4,2) DEFAULT '0'::numeric NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    exception_reason character varying(200),
    approved_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN attendance_records.clock_in_source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attendance_records.clock_in_source IS '1:APP 2:企业微信 3:人工补录';


--
-- Name: COLUMN attendance_records.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.attendance_records.status IS '1:正常 2:迟到 3:早退 4:缺勤 5:请假';


--
-- Name: attendance_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.attendance_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attendance_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.attendance_records_id_seq OWNED BY public.attendance_records.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


--
-- Name: chat_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_logs (
    id bigint NOT NULL,
    agent_id character varying(100),
    direction character varying(255) NOT NULL,
    channel character varying(50),
    account_id character varying(100),
    conversation_id character varying(100),
    message_id character varying(100),
    sender character varying(200),
    content text,
    success boolean DEFAULT true NOT NULL,
    error_msg character varying(500),
    session_key character varying(200),
    occurred_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT chat_logs_direction_check CHECK (((direction)::text = ANY ((ARRAY['inbound'::character varying, 'outbound'::character varying])::text[])))
);


--
-- Name: chat_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_logs_id_seq OWNED BY public.chat_logs.id;


--
-- Name: competitor_hot_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competitor_hot_products (
    id bigint NOT NULL,
    competitor_id bigint NOT NULL,
    competitor_product_id bigint NOT NULL,
    identified_date date NOT NULL,
    heat_score numeric(5,2),
    evidence json,
    our_product_id bigint,
    recommendation smallint,
    reviewed_by bigint,
    reviewed_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN competitor_hot_products.evidence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_hot_products.evidence IS '热度证据';


--
-- Name: COLUMN competitor_hot_products.recommendation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_hot_products.recommendation IS '1:引进建议 2:加量建议 3:已有无需操作';


--
-- Name: competitor_hot_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competitor_hot_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competitor_hot_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competitor_hot_products_id_seq OWNED BY public.competitor_hot_products.id;


--
-- Name: competitor_price_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competitor_price_records (
    id bigint NOT NULL,
    competitor_product_id bigint NOT NULL,
    competitor_id bigint NOT NULL,
    product_id bigint,
    price numeric(12,2) NOT NULL,
    original_price numeric(12,2),
    is_promotion boolean DEFAULT false NOT NULL,
    collect_source smallint DEFAULT '1'::smallint NOT NULL,
    collect_channel character varying(100),
    image_url character varying(500),
    collected_by bigint,
    collected_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN competitor_price_records.original_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_price_records.original_price IS '划线价';


--
-- Name: COLUMN competitor_price_records.collect_source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_price_records.collect_source IS '1:人工录入 2:APP扫码 3:爬虫 4:第三方API';


--
-- Name: COLUMN competitor_price_records.image_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_price_records.image_url IS '采集凭证图片';


--
-- Name: competitor_price_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competitor_price_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competitor_price_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competitor_price_records_id_seq OWNED BY public.competitor_price_records.id;


--
-- Name: competitor_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competitor_products (
    id bigint NOT NULL,
    competitor_id bigint NOT NULL,
    product_id bigint,
    competitor_product_name character varying(200) NOT NULL,
    competitor_product_code character varying(100),
    spec character varying(200),
    match_confidence numeric(5,4),
    is_manually_confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN competitor_products.match_confidence; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitor_products.match_confidence IS '与自家商品匹配置信度';


--
-- Name: competitor_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competitor_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competitor_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competitor_products_id_seq OWNED BY public.competitor_products.id;


--
-- Name: competitors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competitors (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name character varying(200) NOT NULL,
    brand character varying(100),
    address character varying(300),
    latitude numeric(10,7),
    longitude numeric(10,7),
    distance_to_store numeric(8,2),
    nearest_store_id bigint,
    channels json,
    status smallint DEFAULT '1'::smallint NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN competitors.distance_to_store; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitors.distance_to_store IS '距最近自家门店（米）';


--
-- Name: COLUMN competitors.channels; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitors.channels IS '情报采集渠道';


--
-- Name: COLUMN competitors.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.competitors.status IS '0:停止监控 1:正常监控';


--
-- Name: competitors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competitors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competitors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competitors_id_seq OWNED BY public.competitors.id;


--
-- Name: custom_report_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_report_templates (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    created_by bigint NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    data_sources json,
    filters json,
    columns json,
    chart_types json,
    schedule_cron character varying(50),
    is_shared boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN custom_report_templates.data_sources; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.custom_report_templates.data_sources IS '数据源配置';


--
-- Name: COLUMN custom_report_templates.filters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.custom_report_templates.filters IS '筛选条件配置';


--
-- Name: COLUMN custom_report_templates.columns; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.custom_report_templates.columns IS '报表列定义';


--
-- Name: COLUMN custom_report_templates.schedule_cron; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.custom_report_templates.schedule_cron IS '定时生成表达式';


--
-- Name: custom_report_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_report_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_report_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_report_templates_id_seq OWNED BY public.custom_report_templates.id;


--
-- Name: customer_follow_ups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_follow_ups (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    store_id bigint NOT NULL,
    type smallint DEFAULT '1'::smallint NOT NULL,
    content text NOT NULL,
    follow_up_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    next_follow_up_at date,
    operator_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN customer_follow_ups.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_follow_ups.type IS '1:电话 2:微信 3:到店 4:短信 5:其他';


--
-- Name: customer_follow_ups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_follow_ups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_follow_ups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_follow_ups_id_seq OWNED BY public.customer_follow_ups.id;


--
-- Name: customer_order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_order_items (
    id bigint NOT NULL,
    customer_order_id bigint NOT NULL,
    product_id bigint,
    product_name character varying(100) NOT NULL,
    qty numeric(10,3) NOT NULL,
    unit character varying(20),
    unit_price numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    subtotal numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: customer_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_order_items_id_seq OWNED BY public.customer_order_items.id;


--
-- Name: customer_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer_orders (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    order_no character varying(32) NOT NULL,
    customer_id bigint,
    customer_name character varying(50),
    customer_phone character varying(20),
    type smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    total_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    discount_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    paid_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    payment_method smallint,
    delivery_address character varying(255),
    delivery_at timestamp(0) without time zone,
    remark text,
    operator_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN customer_orders.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_orders.type IS '1:预订 2:送货 3:团购 4:自提';


--
-- Name: COLUMN customer_orders.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_orders.status IS '1:待确认 2:待付款 3:待发货 4:已完成 5:已取消';


--
-- Name: COLUMN customer_orders.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customer_orders.payment_method IS '1:现金 2:微信 3:支付宝 4:银行卡';


--
-- Name: customer_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_orders_id_seq OWNED BY public.customer_orders.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    phone character varying(20),
    gender smallint DEFAULT '0'::smallint NOT NULL,
    birthday date,
    level smallint DEFAULT '1'::smallint NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    total_spent numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    order_count integer DEFAULT 0 NOT NULL,
    last_order_at timestamp(0) without time zone,
    tags json,
    address character varying(255),
    source smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    notes text,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN customers.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.gender IS '0:未知 1:男 2:女';


--
-- Name: COLUMN customers.level; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.level IS '会员等级 1:普通 2:银卡 3:金卡';


--
-- Name: COLUMN customers.total_spent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.total_spent IS '累计消费';


--
-- Name: COLUMN customers.tags; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.tags IS '分群标签数组';


--
-- Name: COLUMN customers.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.source IS '1:手动 2:AI 3:导入';


--
-- Name: COLUMN customers.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.customers.status IS '0:流失 1:正常 2:黑名单';


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: daily_operation_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_operation_logs (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    date date NOT NULL,
    occurred_at timestamp(0) without time zone NOT NULL,
    source smallint NOT NULL,
    content text NOT NULL,
    intent character varying(32) DEFAULT 'note'::character varying NOT NULL,
    is_operational boolean DEFAULT false NOT NULL,
    product_id bigint,
    qty_change numeric(10,3),
    reference_type character varying(64),
    reference_id bigint,
    operator_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    is_failed boolean DEFAULT false NOT NULL,
    http_status_code smallint,
    error_message character varying(500)
);


--
-- Name: COLUMN daily_operation_logs.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.daily_operation_logs.source IS '1=AI助手 2=手动API 3=Filament后台';


--
-- Name: COLUMN daily_operation_logs.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.daily_operation_logs.content IS '操作描述或原始指令文本';


--
-- Name: COLUMN daily_operation_logs.intent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.daily_operation_logs.intent IS 'stock_in|stock_out|sold_out|damage|adjust|supplement|note|other';


--
-- Name: COLUMN daily_operation_logs.is_operational; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.daily_operation_logs.is_operational IS '是否影响库存/销售数据';


--
-- Name: COLUMN daily_operation_logs.qty_change; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.daily_operation_logs.qty_change IS '库存变动量（正入负出）';


--
-- Name: daily_operation_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.daily_operation_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: daily_operation_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.daily_operation_logs_id_seq OWNED BY public.daily_operation_logs.id;


--
-- Name: damage_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.damage_records (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    purchase_order_item_id bigint,
    supplier_id bigint,
    qty numeric(10,3) NOT NULL,
    unit_cost numeric(10,4),
    total_claimed numeric(10,2),
    reason character varying(100) NOT NULL,
    image_paths json,
    status smallint DEFAULT '1'::smallint NOT NULL,
    occurred_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    operator_id bigint,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: damage_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.damage_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: damage_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.damage_records_id_seq OWNED BY public.damage_records.id;


--
-- Name: dashboard_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dashboard_configs (
    id bigint NOT NULL,
    user_id bigint,
    store_id bigint,
    name character varying(100) NOT NULL,
    scope smallint DEFAULT '3'::smallint NOT NULL,
    widgets json,
    filters json,
    refresh_interval integer DEFAULT 0 NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN dashboard_configs.scope; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dashboard_configs.scope IS '1:个人 2:门店 3:区域 4:总部';


--
-- Name: COLUMN dashboard_configs.widgets; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dashboard_configs.widgets IS '组件配置数组';


--
-- Name: COLUMN dashboard_configs.filters; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dashboard_configs.filters IS '默认筛选条件';


--
-- Name: COLUMN dashboard_configs.refresh_interval; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dashboard_configs.refresh_interval IS '自动刷新间隔（秒），0不刷新';


--
-- Name: dashboard_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dashboard_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboard_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dashboard_configs_id_seq OWNED BY public.dashboard_configs.id;


--
-- Name: employee_store_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee_store_history (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    from_store_id bigint,
    to_store_id bigint NOT NULL,
    effective_date date NOT NULL,
    reason character varying(200),
    approved_by bigint,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: employee_store_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employee_store_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employee_store_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employee_store_history_id_seq OWNED BY public.employee_store_history.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    user_id bigint,
    current_store_id bigint,
    employee_no character varying(50),
    name character varying(100) NOT NULL,
    phone character varying(20),
    id_card_no character varying(100),
    gender smallint,
    birth_date date,
    education smallint,
    "position" character varying(100),
    position_level smallint DEFAULT '1'::smallint NOT NULL,
    hire_date date,
    contract_expire_date date,
    probation_end_date date,
    status smallint DEFAULT '1'::smallint NOT NULL,
    resign_date date,
    resign_reason text,
    base_salary numeric(10,2),
    emergency_contact character varying(100),
    emergency_phone character varying(20),
    skills json,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN employees.id_card_no; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.id_card_no IS '加密存储';


--
-- Name: COLUMN employees.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.gender IS '1:男 2:女';


--
-- Name: COLUMN employees.education; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.education IS '1:初中及以下 2:高中/中专 3:大专 4:本科 5:研究生';


--
-- Name: COLUMN employees.position_level; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.position_level IS '1:店员 2:主管 3:店长 4:区域 5:总部';


--
-- Name: COLUMN employees.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.status IS '1:试用期 2:正式 3:离职 4:暂停';


--
-- Name: COLUMN employees.skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.employees.skills IS '技能标签';


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: expense_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expense_categories (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    parent_id bigint,
    name character varying(100) NOT NULL,
    code character varying(50),
    is_cogs boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN expense_categories.is_cogs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expense_categories.is_cogs IS '是否属于销售成本';


--
-- Name: expense_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expense_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_categories_id_seq OWNED BY public.expense_categories.id;


--
-- Name: expenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expenses (
    id bigint NOT NULL,
    store_id bigint,
    category_id bigint NOT NULL,
    expense_no character varying(50) NOT NULL,
    amount numeric(12,2) NOT NULL,
    expense_date date NOT NULL,
    description text,
    input_method smallint DEFAULT '1'::smallint NOT NULL,
    ai_session_message_id bigint,
    attachment_urls json,
    vendor_name character varying(200),
    supplier_id bigint,
    payment_method smallint DEFAULT '1'::smallint NOT NULL,
    payment_status smallint DEFAULT '1'::smallint NOT NULL,
    created_by bigint,
    approved_by bigint,
    approved_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN expenses.input_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expenses.input_method IS '1:手动录入 2:AI录入 3:系统自动';


--
-- Name: COLUMN expenses.attachment_urls; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expenses.attachment_urls IS '凭证附件URL数组';


--
-- Name: COLUMN expenses.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expenses.payment_method IS '1:现金 2:转账 3:微信支付 4:支付宝 5:企业网银';


--
-- Name: COLUMN expenses.payment_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.expenses.payment_status IS '1:待支付 2:已支付 3:已报销';


--
-- Name: expenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expenses_id_seq OWNED BY public.expenses.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: intelligence_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.intelligence_reports (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    store_id bigint,
    report_period_start date NOT NULL,
    report_period_end date NOT NULL,
    report_type smallint DEFAULT '1'::smallint NOT NULL,
    price_gap_summary json,
    hot_products_summary json,
    ai_insights text,
    action_recommendations json,
    generated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_auto_generated boolean DEFAULT true NOT NULL
);


--
-- Name: COLUMN intelligence_reports.report_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.intelligence_reports.report_type IS '1:周报 2:月报 3:专项分析';


--
-- Name: intelligence_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.intelligence_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: intelligence_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.intelligence_reports_id_seq OWNED BY public.intelligence_reports.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    current_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    available_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    locked_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    avg_cost numeric(12,4) DEFAULT '0'::numeric NOT NULL,
    last_in_at timestamp(0) without time zone,
    last_out_at timestamp(0) without time zone,
    last_counted_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_sold_at timestamp(0) without time zone
);


--
-- Name: COLUMN inventory.current_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory.current_qty IS '当前库存量';


--
-- Name: COLUMN inventory.available_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory.available_qty IS '可用库存';


--
-- Name: COLUMN inventory.locked_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory.locked_qty IS '锁定量（已下单未入库）';


--
-- Name: COLUMN inventory.avg_cost; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory.avg_cost IS '移动加权平均成本';


--
-- Name: COLUMN inventory.last_sold_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory.last_sold_at IS '最后一次库存归零的时间，有补货后清空';


--
-- Name: inventory_daily_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_daily_snapshots (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    date date NOT NULL,
    opening_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    received_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    sold_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    damage_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    adjustment_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    closing_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    sold_out_at timestamp(0) without time zone
);


--
-- Name: COLUMN inventory_daily_snapshots.opening_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.opening_qty IS '往日库存（当天第一笔交易前）';


--
-- Name: COLUMN inventory_daily_snapshots.received_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.received_qty IS '今日进货合计';


--
-- Name: COLUMN inventory_daily_snapshots.sold_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.sold_qty IS '今日销售出库合计';


--
-- Name: COLUMN inventory_daily_snapshots.damage_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.damage_qty IS '今日损耗合计';


--
-- Name: COLUMN inventory_daily_snapshots.adjustment_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.adjustment_qty IS '今日盘点调整';


--
-- Name: COLUMN inventory_daily_snapshots.closing_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_daily_snapshots.closing_qty IS '今日结算库存（实时更新）';


--
-- Name: inventory_daily_snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_daily_snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_daily_snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_daily_snapshots_id_seq OWNED BY public.inventory_daily_snapshots.id;


--
-- Name: inventory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_id_seq OWNED BY public.inventory.id;


--
-- Name: inventory_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_transactions (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    transaction_type smallint NOT NULL,
    qty_change numeric(10,3) NOT NULL,
    qty_before numeric(10,3) NOT NULL,
    qty_after numeric(10,3) NOT NULL,
    unit_cost numeric(12,4),
    total_cost numeric(12,2),
    reference_type character varying(50),
    reference_id bigint,
    batch_no character varying(100),
    expiry_date date,
    operator_id bigint,
    notes character varying(500),
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN inventory_transactions.transaction_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_transactions.transaction_type IS '1:采购入库 2:销售出库 3:损耗 4:盘点调整 5:促销出库 6:调拨入 7:调拨出 8:退货入库';


--
-- Name: COLUMN inventory_transactions.qty_change; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_transactions.qty_change IS '变动量（正入负出）';


--
-- Name: COLUMN inventory_transactions.reference_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_transactions.reference_type IS '关联单据类型';


--
-- Name: COLUMN inventory_transactions.reference_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_transactions.reference_id IS '关联单据ID';


--
-- Name: COLUMN inventory_transactions.expiry_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.inventory_transactions.expiry_date IS '批次到期日';


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_transactions_id_seq OWNED BY public.inventory_transactions.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leave_requests (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    store_id bigint NOT NULL,
    leave_type smallint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    total_days numeric(4,1) NOT NULL,
    reason text,
    status smallint DEFAULT '1'::smallint NOT NULL,
    approved_by bigint,
    approved_at timestamp(0) without time zone,
    reject_reason text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN leave_requests.leave_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.leave_requests.leave_type IS '1:事假 2:病假 3:年假 4:婚假 5:产假/陪产假 6:其他';


--
-- Name: COLUMN leave_requests.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.leave_requests.status IS '1:待审批 2:已批准 3:已拒绝 4:已撤销';


--
-- Name: leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leave_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leave_requests_id_seq OWNED BY public.leave_requests.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    logo_url character varying(500),
    contact_phone character varying(20),
    settings json,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN organizations.settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.organizations.settings IS '系统配置：功能开关、AI参数全局默认值';


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    module character varying(50) NOT NULL,
    code character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    type smallint DEFAULT '2'::smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN permissions.module; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.permissions.module IS '模块标识';


--
-- Name: COLUMN permissions.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.permissions.code IS '如 inventory.product.create';


--
-- Name: COLUMN permissions.type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.permissions.type IS '1:菜单 2:操作 3:数据';


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    published boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_categories (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    parent_id bigint,
    name character varying(100) NOT NULL,
    code character varying(50),
    sort_order integer DEFAULT 0 NOT NULL,
    icon_url character varying(500),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.product_categories.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    category_id bigint,
    name character varying(200) NOT NULL,
    code character varying(100),
    barcode character varying(100),
    brand character varying(100),
    unit character varying(20) NOT NULL,
    spec character varying(200),
    image_urls json,
    description text,
    shelf_life_days integer,
    storage_condition smallint DEFAULT '1'::smallint NOT NULL,
    is_fresh boolean DEFAULT false NOT NULL,
    min_order_qty numeric(10,3) DEFAULT '1'::numeric NOT NULL,
    purchase_unit character varying(20),
    purchase_unit_qty numeric(10,3),
    status smallint DEFAULT '1'::smallint NOT NULL,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    supplier_id bigint
);


--
-- Name: COLUMN products.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.code IS 'SKU编码';


--
-- Name: COLUMN products.unit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.unit IS '基本单位：斤/个/箱';


--
-- Name: COLUMN products.spec; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.spec IS '规格描述：500g/袋';


--
-- Name: COLUMN products.shelf_life_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.shelf_life_days IS '保质期天数';


--
-- Name: COLUMN products.storage_condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.storage_condition IS '1:常温 2:冷藏 3:冷冻';


--
-- Name: COLUMN products.is_fresh; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.is_fresh IS '是否生鲜品';


--
-- Name: COLUMN products.min_order_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.min_order_qty IS '最小采购量';


--
-- Name: COLUMN products.purchase_unit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.purchase_unit IS '采购单位：箱';


--
-- Name: COLUMN products.purchase_unit_qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.purchase_unit_qty IS '采购单位含基本单位数量';


--
-- Name: COLUMN products.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.status IS '0:下架 1:正常 2:待审核';


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: promotion_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_items (
    id bigint NOT NULL,
    promotion_id bigint NOT NULL,
    product_id bigint NOT NULL,
    original_price numeric(12,2) NOT NULL,
    promotion_price numeric(12,2) NOT NULL,
    discount_rate numeric(5,4),
    ai_suggested_price numeric(12,2),
    cost_price numeric(12,2),
    stock_qty_at_start numeric(10,3),
    target_clear_qty numeric(10,3),
    actual_sold_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN promotion_items.cost_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_items.cost_price IS '成本价（防止亏本）';


--
-- Name: promotion_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promotion_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promotion_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promotion_items_id_seq OWNED BY public.promotion_items.id;


--
-- Name: promotion_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_reviews (
    id bigint NOT NULL,
    promotion_id bigint NOT NULL,
    store_id bigint NOT NULL,
    total_revenue numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    total_cost numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    gross_profit numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    gross_profit_rate numeric(6,4),
    clear_rate numeric(5,4),
    waste_amount_prevented numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    customer_traffic_change numeric(6,4),
    ai_effectiveness_score numeric(5,2),
    lessons_learned text,
    recommendations json,
    generated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: COLUMN promotion_reviews.clear_rate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_reviews.clear_rate IS '清货率';


--
-- Name: COLUMN promotion_reviews.customer_traffic_change; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_reviews.customer_traffic_change IS '客流变化率';


--
-- Name: promotion_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promotion_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promotion_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promotion_reviews_id_seq OWNED BY public.promotion_reviews.id;


--
-- Name: promotion_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotion_rules (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name character varying(200) NOT NULL,
    trigger_type smallint NOT NULL,
    trigger_condition json,
    promotion_type smallint NOT NULL,
    pricing_strategy smallint DEFAULT '1'::smallint NOT NULL,
    max_discount_rate numeric(5,4),
    apply_to smallint DEFAULT '1'::smallint NOT NULL,
    apply_target_ids json,
    auto_execute boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN promotion_rules.trigger_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.trigger_type IS '1:库存阈值 2:临期天数 3:滞销天数 4:手动触发 5:节假日';


--
-- Name: COLUMN promotion_rules.trigger_condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.trigger_condition IS '触发条件参数';


--
-- Name: COLUMN promotion_rules.promotion_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.promotion_type IS '1:折扣 2:满减 3:买赠 4:捆绑销售 5:限时特价';


--
-- Name: COLUMN promotion_rules.pricing_strategy; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.pricing_strategy IS '1:固定折扣 2:AI动态定价 3:清零定价';


--
-- Name: COLUMN promotion_rules.max_discount_rate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.max_discount_rate IS '最大折扣率下限';


--
-- Name: COLUMN promotion_rules.apply_to; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.apply_to IS '1:全品类 2:指定分类 3:指定商品';


--
-- Name: COLUMN promotion_rules.auto_execute; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotion_rules.auto_execute IS '是否自动执行';


--
-- Name: promotion_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promotion_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promotion_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promotion_rules_id_seq OWNED BY public.promotion_rules.id;


--
-- Name: promotions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.promotions (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    rule_id bigint,
    name character varying(200) NOT NULL,
    trigger_source smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    started_at timestamp(0) without time zone,
    ended_at timestamp(0) without time zone,
    ai_analysis json,
    total_sales_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    total_sales_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    total_saved_waste_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    created_by bigint,
    approved_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN promotions.trigger_source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.trigger_source IS '1:AI自动触发 2:店长手动 3:总部下发';


--
-- Name: COLUMN promotions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.status IS '1:待审核 2:进行中 3:已暂停 4:已结束 5:已取消';


--
-- Name: COLUMN promotions.ai_analysis; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.promotions.ai_analysis IS 'AI触发时的分析快照';


--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.promotions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_order_items (
    id bigint NOT NULL,
    purchase_order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    ordered_qty numeric(10,3) NOT NULL,
    received_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    unit_price numeric(12,4) NOT NULL,
    total_price numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    supplier_id bigint
);


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_order_items_id_seq OWNED BY public.purchase_order_items.id;


--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.purchase_orders (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    supplier_id bigint,
    order_no character varying(50) NOT NULL,
    order_type smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    expected_delivery_date date,
    actual_delivery_date date,
    total_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    notes text,
    created_by bigint,
    approved_by bigint,
    approved_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone,
    image_paths json
);


--
-- Name: COLUMN purchase_orders.order_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.purchase_orders.order_type IS '1:AI建议单 2:手动创建 3:紧急补货';


--
-- Name: COLUMN purchase_orders.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.purchase_orders.status IS '1:草稿 2:待审核 3:已确认 4:配送中 5:已收货 6:已取消';


--
-- Name: COLUMN purchase_orders.image_paths; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.purchase_orders.image_paths IS '上传的进货单据图片 /storage URL 数组';


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.purchase_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.purchase_orders_id_seq OWNED BY public.purchase_orders.id;


--
-- Name: quick_action_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_action_items (
    id bigint NOT NULL,
    quick_action_id bigint NOT NULL,
    emoji character varying(16),
    label character varying(50) NOT NULL,
    "desc" character varying(100),
    item_type character varying(20) DEFAULT 'prompt'::character varying NOT NULL,
    route character varying(200),
    prompt text,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN quick_action_items."desc"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_action_items."desc" IS '副标题说明';


--
-- Name: COLUMN quick_action_items.item_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_action_items.item_type IS 'route|prompt';


--
-- Name: COLUMN quick_action_items.route; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_action_items.route IS 'route 类型：小程序页路径，如 /pages/report/report';


--
-- Name: COLUMN quick_action_items.prompt; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_action_items.prompt IS 'prompt 类型：发给 AI 的文字';


--
-- Name: quick_action_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quick_action_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quick_action_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quick_action_items_id_seq OWNED BY public.quick_action_items.id;


--
-- Name: quick_actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quick_actions (
    id bigint NOT NULL,
    key character varying(50) NOT NULL,
    emoji character varying(16),
    label character varying(50) NOT NULL,
    badge character varying(20),
    action_type character varying(20) DEFAULT 'prompt'::character varying NOT NULL,
    prompt text,
    target_path character varying(200),
    target_title character varying(50),
    web_label character varying(50),
    admin_only boolean DEFAULT false NOT NULL,
    store_id bigint,
    enabled boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN quick_actions.key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.key IS '按钮标识（data-key，用于样式 qa-chip-{key}）';


--
-- Name: COLUMN quick_actions.badge; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.badge IS '角标文字，空则不显示';


--
-- Name: COLUMN quick_actions.action_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.action_type IS 'prompt|web|open|menu';


--
-- Name: COLUMN quick_actions.prompt; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.prompt IS 'prompt/web 类型：发给 AI 的文字';


--
-- Name: COLUMN quick_actions.target_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.target_path IS 'web/open 类型：web-view 路径，如 /inventory、/admin/sso';


--
-- Name: COLUMN quick_actions.target_title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.target_title IS 'web-view 页标题';


--
-- Name: COLUMN quick_actions.web_label; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.web_label IS 'web 类型「打开完整页」按钮文字';


--
-- Name: COLUMN quick_actions.admin_only; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.admin_only IS '仅 is_admin 用户可见';


--
-- Name: COLUMN quick_actions.store_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.store_id IS 'null=全门店通用，否则仅该门店';


--
-- Name: quick_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quick_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quick_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quick_actions_id_seq OWNED BY public.quick_actions.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    parent_id bigint,
    name character varying(100) NOT NULL,
    code character varying(50),
    manager_user_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    store_id bigint,
    report_type character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    content text,
    data_snapshot json,
    ai_analysis text,
    charts_config json,
    status smallint DEFAULT '1'::smallint NOT NULL,
    is_auto_generated boolean DEFAULT true NOT NULL,
    generated_by bigint,
    generated_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN reports.report_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reports.report_type IS 'daily_review, weekly_review, monthly_review, custom';


--
-- Name: COLUMN reports.data_snapshot; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reports.data_snapshot IS '核心指标数据快照';


--
-- Name: COLUMN reports.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.reports.status IS '1:生成中 2:已完成 3:失败';


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: resumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resumes (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name character varying(100),
    phone character varying(20),
    gender smallint DEFAULT '0'::smallint NOT NULL,
    age smallint,
    districts json,
    work_types json,
    positions json,
    experience_years numeric(3,1),
    salary_min integer,
    salary_max integer,
    salary_unit smallint DEFAULT '1'::smallint NOT NULL,
    education smallint,
    availability_date date,
    languages json,
    skills json,
    raw_text text,
    source smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    notes text,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN resumes.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.gender IS '0:未知 1:男 2:女';


--
-- Name: COLUMN resumes.districts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.districts IS '意向工作区域，如["筲箕湾","柴湾"]';


--
-- Name: COLUMN resumes.work_types; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.work_types IS '工作类型，如["全职","小时工"]';


--
-- Name: COLUMN resumes.positions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.positions IS '意向岗位，如["收银员","理货员"]';


--
-- Name: COLUMN resumes.experience_years; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.experience_years IS '工作经验年数';


--
-- Name: COLUMN resumes.salary_min; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.salary_min IS '薪资下限';


--
-- Name: COLUMN resumes.salary_max; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.salary_max IS '薪资上限';


--
-- Name: COLUMN resumes.salary_unit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.salary_unit IS '1:月 2:日 3:小时';


--
-- Name: COLUMN resumes.education; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.education IS '1:初中 2:高中 3:大专 4:本科';


--
-- Name: COLUMN resumes.availability_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.availability_date IS '最早到岗日期';


--
-- Name: COLUMN resumes.languages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.languages IS '语言能力，如["粤语","普通话"]';


--
-- Name: COLUMN resumes.skills; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.skills IS '技能标签，如["生鲜处理","收银"]';


--
-- Name: COLUMN resumes.raw_text; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.raw_text IS '原始输入文本';


--
-- Name: COLUMN resumes.source; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.source IS '1:手动录入 2:AI解析 3:文件上传';


--
-- Name: COLUMN resumes.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.resumes.status IS '0:无效 1:求职中 2:已入职 3:暂不求职';


--
-- Name: resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resumes_id_seq OWNED BY public.resumes.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying(100) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    scope smallint DEFAULT '3'::smallint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN roles.code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.roles.code IS 'SUPER_ADMIN, REGION_BUYER, STORE_MANAGER, STORE_STAFF';


--
-- Name: COLUMN roles.scope; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.roles.scope IS '1:总部 2:区域 3:门店';


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: saas_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saas_integrations (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    store_id bigint,
    platform character varying(50) NOT NULL,
    app_id character varying(200),
    app_secret text,
    access_token text,
    token_expires_at timestamp(0) without time zone,
    webhook_url character varying(500),
    config json,
    status smallint DEFAULT '1'::smallint NOT NULL,
    last_sync_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN saas_integrations.platform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.saas_integrations.platform IS 'wework, dingtalk, pos_system, erp...';


--
-- Name: COLUMN saas_integrations.app_secret; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.saas_integrations.app_secret IS '加密存储';


--
-- Name: COLUMN saas_integrations.access_token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.saas_integrations.access_token IS '加密存储';


--
-- Name: COLUMN saas_integrations.config; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.saas_integrations.config IS '平台特定配置参数';


--
-- Name: COLUMN saas_integrations.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.saas_integrations.status IS '0:禁用 1:正常 2:故障';


--
-- Name: saas_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saas_integrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saas_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saas_integrations_id_seq OWNED BY public.saas_integrations.id;


--
-- Name: salary_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.salary_records (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    store_id bigint NOT NULL,
    year integer NOT NULL,
    month smallint NOT NULL,
    work_days numeric(4,1) DEFAULT '0'::numeric NOT NULL,
    actual_work_days numeric(4,1) DEFAULT '0'::numeric NOT NULL,
    base_salary numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    overtime_pay numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    performance_bonus numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    sales_commission numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    deductions numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    social_insurance numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    income_tax numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    gross_salary numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    net_salary numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    payment_status smallint DEFAULT '1'::smallint NOT NULL,
    paid_at timestamp(0) without time zone,
    notes text,
    generated_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN salary_records.payment_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.salary_records.payment_status IS '1:待发放 2:已发放 3:暂停';


--
-- Name: salary_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.salary_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: salary_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.salary_records_id_seq OWNED BY public.salary_records.id;


--
-- Name: sales_daily_summaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_daily_summaries (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    product_id bigint NOT NULL,
    sale_date date NOT NULL,
    sales_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    sales_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    transaction_count integer DEFAULT 0 NOT NULL,
    avg_selling_price numeric(10,4),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    pos_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    pos_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    supplement_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    supplement_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    ai_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    ai_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL
);


--
-- Name: sales_daily_summaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_daily_summaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_daily_summaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_daily_summaries_id_seq OWNED BY public.sales_daily_summaries.id;


--
-- Name: sales_order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_order_items (
    id bigint NOT NULL,
    sales_order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    qty numeric(10,3) NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    cost_price numeric(10,4),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN sales_order_items.qty; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_order_items.qty IS '数量';


--
-- Name: COLUMN sales_order_items.unit_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_order_items.unit_price IS '售价';


--
-- Name: COLUMN sales_order_items.discount_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_order_items.discount_amount IS '行级折扣';


--
-- Name: COLUMN sales_order_items.subtotal; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_order_items.subtotal IS '小计';


--
-- Name: COLUMN sales_order_items.cost_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_order_items.cost_price IS '成本价（用于毛利计算）';


--
-- Name: sales_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_order_items_id_seq OWNED BY public.sales_order_items.id;


--
-- Name: sales_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_orders (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    order_no character varying(50) NOT NULL,
    cashier_id bigint,
    total_amount numeric(10,2) NOT NULL,
    discount_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    paid_amount numeric(10,2) NOT NULL,
    payment_method smallint DEFAULT '1'::smallint NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    sold_at timestamp(0) without time zone NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN sales_orders.order_no; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.order_no IS '流水号';


--
-- Name: COLUMN sales_orders.cashier_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.cashier_id IS '收银员';


--
-- Name: COLUMN sales_orders.total_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.total_amount IS '应收金额';


--
-- Name: COLUMN sales_orders.discount_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.discount_amount IS '整单折扣';


--
-- Name: COLUMN sales_orders.paid_amount; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.paid_amount IS '实收金额';


--
-- Name: COLUMN sales_orders.payment_method; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.payment_method IS '1:现金 2:微信 3:支付宝 4:银行卡 5:混合';


--
-- Name: COLUMN sales_orders.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.status IS '1:已完成 2:已退款 3:部分退款';


--
-- Name: COLUMN sales_orders.sold_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_orders.sold_at IS '交易时间';


--
-- Name: sales_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_orders_id_seq OWNED BY public.sales_orders.id;


--
-- Name: sales_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_uploads (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    uploaded_by bigint NOT NULL,
    original_filename character varying(255) NOT NULL,
    file_path character varying(500) NOT NULL,
    sale_date date NOT NULL,
    status smallint DEFAULT '0'::smallint NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    processed_items integer DEFAULT 0 NOT NULL,
    failed_items integer DEFAULT 0 NOT NULL,
    error_message text,
    raw_rows json,
    ai_result json,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN sales_uploads.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_uploads.status IS '0=pending 1=processing 2=completed 3=failed';


--
-- Name: COLUMN sales_uploads.raw_rows; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_uploads.raw_rows IS 'Excel解析出的原始行数据';


--
-- Name: COLUMN sales_uploads.ai_result; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sales_uploads.ai_result IS 'AI分析映射结果';


--
-- Name: sales_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sales_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sales_uploads_id_seq OWNED BY public.sales_uploads.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    schedule_date date NOT NULL,
    shift_start time(0) without time zone NOT NULL,
    shift_end time(0) without time zone NOT NULL,
    shift_type smallint DEFAULT '1'::smallint NOT NULL,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN schedules.shift_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.schedules.shift_type IS '1:早班 2:中班 3:晚班 4:全天';


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stores (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    region_id bigint,
    name character varying(100) NOT NULL,
    code character varying(50),
    address character varying(300),
    province character varying(50),
    city character varying(50),
    district character varying(50),
    latitude numeric(10,7),
    longitude numeric(10,7),
    manager_user_id bigint,
    business_hours character varying(100),
    status smallint DEFAULT '1'::smallint NOT NULL,
    settings json,
    opened_at date,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN stores.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stores.status IS '0:关闭 1:正常 2:装修中';


--
-- Name: COLUMN stores.settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.stores.settings IS '门店级配置，覆盖总部默认值';


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: supplier_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_products (
    id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    product_id bigint NOT NULL,
    supplier_product_code character varying(100),
    purchase_price numeric(12,2) NOT NULL,
    min_order_qty numeric(10,3) DEFAULT '1'::numeric NOT NULL,
    delivery_lead_days integer,
    is_primary boolean DEFAULT false NOT NULL,
    price_effective_date date,
    price_expired_date date,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN supplier_products.supplier_product_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.supplier_products.supplier_product_code IS '供应商侧商品编码';


--
-- Name: COLUMN supplier_products.purchase_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.supplier_products.purchase_price IS '当前采购单价';


--
-- Name: COLUMN supplier_products.is_primary; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.supplier_products.is_primary IS '是否为该商品首选供应商';


--
-- Name: supplier_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supplier_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supplier_products_id_seq OWNED BY public.supplier_products.id;


--
-- Name: supplier_refund_claim_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_refund_claim_items (
    id bigint NOT NULL,
    claim_id bigint NOT NULL,
    damage_record_id bigint NOT NULL,
    product_id bigint NOT NULL,
    product_name character varying(100) NOT NULL,
    qty numeric(10,3) NOT NULL,
    unit_cost numeric(10,4),
    claimed_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    purchase_order_id bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: supplier_refund_claim_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supplier_refund_claim_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_refund_claim_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supplier_refund_claim_items_id_seq OWNED BY public.supplier_refund_claim_items.id;


--
-- Name: supplier_refund_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.supplier_refund_claims (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    supplier_id bigint NOT NULL,
    claim_no character varying(30) NOT NULL,
    status smallint DEFAULT '1'::smallint NOT NULL,
    total_items integer DEFAULT 0 NOT NULL,
    total_qty numeric(10,3) DEFAULT '0'::numeric NOT NULL,
    total_amount numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    submitted_at timestamp(0) without time zone,
    resolved_at timestamp(0) without time zone,
    notes text,
    created_by bigint,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: supplier_refund_claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.supplier_refund_claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supplier_refund_claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.supplier_refund_claims_id_seq OWNED BY public.supplier_refund_claims.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name character varying(200) NOT NULL,
    code character varying(50),
    contact_name character varying(100),
    contact_phone character varying(20),
    contact_wechat character varying(100),
    address character varying(300),
    business_license character varying(200),
    payment_terms smallint DEFAULT '1'::smallint NOT NULL,
    payment_days integer DEFAULT 0 NOT NULL,
    delivery_lead_days integer DEFAULT 1 NOT NULL,
    rating smallint,
    status smallint DEFAULT '1'::smallint NOT NULL,
    notes text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    deleted_at timestamp(0) without time zone
);


--
-- Name: COLUMN suppliers.payment_terms; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.suppliers.payment_terms IS '1:现款 2:月结 3:季结';


--
-- Name: COLUMN suppliers.payment_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.suppliers.payment_days IS '账期天数';


--
-- Name: COLUMN suppliers.delivery_lead_days; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.suppliers.delivery_lead_days IS '平均交货周期（天）';


--
-- Name: COLUMN suppliers.rating; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.suppliers.rating IS '1-5星评级';


--
-- Name: COLUMN suppliers.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.suppliers.status IS '0:停用 1:正常';


--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: user_store_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_store_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    store_id bigint,
    region_id bigint,
    role_id bigint NOT NULL,
    granted_by bigint,
    granted_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expired_at timestamp(0) without time zone
);


--
-- Name: user_store_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_store_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_store_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_store_roles_id_seq OWNED BY public.user_store_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    is_admin boolean DEFAULT false NOT NULL,
    username character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: weather_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weather_logs (
    id bigint NOT NULL,
    store_id bigint NOT NULL,
    date date NOT NULL,
    city character varying(50) DEFAULT '香港'::character varying NOT NULL,
    weather character varying(50) NOT NULL,
    temperature_high smallint NOT NULL,
    temperature_low smallint NOT NULL,
    humidity smallint NOT NULL,
    rain_probability smallint NOT NULL,
    uv_index smallint NOT NULL,
    description character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN weather_logs.weather; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.weather IS '天气状况，如晴、多云、阵雨';


--
-- Name: COLUMN weather_logs.temperature_high; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.temperature_high IS '最高气温（摄氏度）';


--
-- Name: COLUMN weather_logs.temperature_low; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.temperature_low IS '最低气温（摄氏度）';


--
-- Name: COLUMN weather_logs.humidity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.humidity IS '湿度百分比';


--
-- Name: COLUMN weather_logs.rain_probability; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.rain_probability IS '降雨概率百分比';


--
-- Name: COLUMN weather_logs.uv_index; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.uv_index IS '紫外线指数 1-11';


--
-- Name: COLUMN weather_logs.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.weather_logs.description IS '门店参考天气提示';


--
-- Name: weather_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.weather_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weather_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.weather_logs_id_seq OWNED BY public.weather_logs.id;


--
-- Name: wework_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wework_users (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    wework_userid character varying(100) NOT NULL,
    wework_openid character varying(100),
    department_ids json,
    bound_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: wework_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wework_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wework_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wework_users_id_seq OWNED BY public.wework_users.id;


--
-- Name: ai_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_messages ALTER COLUMN id SET DEFAULT nextval('public.ai_messages_id_seq'::regclass);


--
-- Name: ai_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_sessions ALTER COLUMN id SET DEFAULT nextval('public.ai_sessions_id_seq'::regclass);


--
-- Name: app_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings ALTER COLUMN id SET DEFAULT nextval('public.app_settings_id_seq'::regclass);


--
-- Name: attendance_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records ALTER COLUMN id SET DEFAULT nextval('public.attendance_records_id_seq'::regclass);


--
-- Name: chat_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_logs ALTER COLUMN id SET DEFAULT nextval('public.chat_logs_id_seq'::regclass);


--
-- Name: competitor_hot_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products ALTER COLUMN id SET DEFAULT nextval('public.competitor_hot_products_id_seq'::regclass);


--
-- Name: competitor_price_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records ALTER COLUMN id SET DEFAULT nextval('public.competitor_price_records_id_seq'::regclass);


--
-- Name: competitor_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_products ALTER COLUMN id SET DEFAULT nextval('public.competitor_products_id_seq'::regclass);


--
-- Name: competitors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitors ALTER COLUMN id SET DEFAULT nextval('public.competitors_id_seq'::regclass);


--
-- Name: custom_report_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_report_templates ALTER COLUMN id SET DEFAULT nextval('public.custom_report_templates_id_seq'::regclass);


--
-- Name: customer_follow_ups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_follow_ups ALTER COLUMN id SET DEFAULT nextval('public.customer_follow_ups_id_seq'::regclass);


--
-- Name: customer_order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_order_items ALTER COLUMN id SET DEFAULT nextval('public.customer_order_items_id_seq'::regclass);


--
-- Name: customer_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders ALTER COLUMN id SET DEFAULT nextval('public.customer_orders_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: daily_operation_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_operation_logs ALTER COLUMN id SET DEFAULT nextval('public.daily_operation_logs_id_seq'::regclass);


--
-- Name: damage_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_records ALTER COLUMN id SET DEFAULT nextval('public.damage_records_id_seq'::regclass);


--
-- Name: dashboard_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_configs ALTER COLUMN id SET DEFAULT nextval('public.dashboard_configs_id_seq'::regclass);


--
-- Name: employee_store_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history ALTER COLUMN id SET DEFAULT nextval('public.employee_store_history_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: expense_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_categories ALTER COLUMN id SET DEFAULT nextval('public.expense_categories_id_seq'::regclass);


--
-- Name: expenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses ALTER COLUMN id SET DEFAULT nextval('public.expenses_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: intelligence_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intelligence_reports ALTER COLUMN id SET DEFAULT nextval('public.intelligence_reports_id_seq'::regclass);


--
-- Name: inventory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory ALTER COLUMN id SET DEFAULT nextval('public.inventory_id_seq'::regclass);


--
-- Name: inventory_daily_snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_daily_snapshots ALTER COLUMN id SET DEFAULT nextval('public.inventory_daily_snapshots_id_seq'::regclass);


--
-- Name: inventory_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_transactions ALTER COLUMN id SET DEFAULT nextval('public.inventory_transactions_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: leave_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN id SET DEFAULT nextval('public.leave_requests_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: product_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: promotion_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_items ALTER COLUMN id SET DEFAULT nextval('public.promotion_items_id_seq'::regclass);


--
-- Name: promotion_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_reviews ALTER COLUMN id SET DEFAULT nextval('public.promotion_reviews_id_seq'::regclass);


--
-- Name: promotion_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules ALTER COLUMN id SET DEFAULT nextval('public.promotion_rules_id_seq'::regclass);


--
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- Name: purchase_order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items ALTER COLUMN id SET DEFAULT nextval('public.purchase_order_items_id_seq'::regclass);


--
-- Name: purchase_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders ALTER COLUMN id SET DEFAULT nextval('public.purchase_orders_id_seq'::regclass);


--
-- Name: quick_action_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_action_items ALTER COLUMN id SET DEFAULT nextval('public.quick_action_items_id_seq'::regclass);


--
-- Name: quick_actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_actions ALTER COLUMN id SET DEFAULT nextval('public.quick_actions_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: resumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes ALTER COLUMN id SET DEFAULT nextval('public.resumes_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: saas_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saas_integrations ALTER COLUMN id SET DEFAULT nextval('public.saas_integrations_id_seq'::regclass);


--
-- Name: salary_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records ALTER COLUMN id SET DEFAULT nextval('public.salary_records_id_seq'::regclass);


--
-- Name: sales_daily_summaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_daily_summaries ALTER COLUMN id SET DEFAULT nextval('public.sales_daily_summaries_id_seq'::regclass);


--
-- Name: sales_order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_order_items ALTER COLUMN id SET DEFAULT nextval('public.sales_order_items_id_seq'::regclass);


--
-- Name: sales_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_orders ALTER COLUMN id SET DEFAULT nextval('public.sales_orders_id_seq'::regclass);


--
-- Name: sales_uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_uploads ALTER COLUMN id SET DEFAULT nextval('public.sales_uploads_id_seq'::regclass);


--
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: supplier_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_products ALTER COLUMN id SET DEFAULT nextval('public.supplier_products_id_seq'::regclass);


--
-- Name: supplier_refund_claim_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claim_items ALTER COLUMN id SET DEFAULT nextval('public.supplier_refund_claim_items_id_seq'::regclass);


--
-- Name: supplier_refund_claims id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claims ALTER COLUMN id SET DEFAULT nextval('public.supplier_refund_claims_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: user_store_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles ALTER COLUMN id SET DEFAULT nextval('public.user_store_roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: weather_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weather_logs ALTER COLUMN id SET DEFAULT nextval('public.weather_logs_id_seq'::regclass);


--
-- Name: wework_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wework_users ALTER COLUMN id SET DEFAULT nextval('public.wework_users_id_seq'::regclass);


--
-- Name: ai_messages ai_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_messages
    ADD CONSTRAINT ai_messages_pkey PRIMARY KEY (id);


--
-- Name: ai_sessions ai_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_pkey PRIMARY KEY (id);


--
-- Name: ai_sessions ai_sessions_session_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_session_uuid_unique UNIQUE (session_uuid);


--
-- Name: app_settings app_settings_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_key_unique UNIQUE (key);


--
-- Name: app_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (id);


--
-- Name: attendance_records attendance_records_employee_id_work_date_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_employee_id_work_date_unique UNIQUE (employee_id, work_date);


--
-- Name: attendance_records attendance_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: chat_logs chat_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_logs
    ADD CONSTRAINT chat_logs_pkey PRIMARY KEY (id);


--
-- Name: competitor_hot_products competitor_hot_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products
    ADD CONSTRAINT competitor_hot_products_pkey PRIMARY KEY (id);


--
-- Name: competitor_price_records competitor_price_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records
    ADD CONSTRAINT competitor_price_records_pkey PRIMARY KEY (id);


--
-- Name: competitor_products competitor_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_products
    ADD CONSTRAINT competitor_products_pkey PRIMARY KEY (id);


--
-- Name: competitors competitors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitors
    ADD CONSTRAINT competitors_pkey PRIMARY KEY (id);


--
-- Name: custom_report_templates custom_report_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_report_templates
    ADD CONSTRAINT custom_report_templates_pkey PRIMARY KEY (id);


--
-- Name: customer_follow_ups customer_follow_ups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_follow_ups
    ADD CONSTRAINT customer_follow_ups_pkey PRIMARY KEY (id);


--
-- Name: customer_order_items customer_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_order_items
    ADD CONSTRAINT customer_order_items_pkey PRIMARY KEY (id);


--
-- Name: customer_orders customer_orders_order_no_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_order_no_unique UNIQUE (order_no);


--
-- Name: customer_orders customer_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: daily_operation_logs daily_operation_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_operation_logs
    ADD CONSTRAINT daily_operation_logs_pkey PRIMARY KEY (id);


--
-- Name: damage_records damage_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_records
    ADD CONSTRAINT damage_records_pkey PRIMARY KEY (id);


--
-- Name: dashboard_configs dashboard_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_configs
    ADD CONSTRAINT dashboard_configs_pkey PRIMARY KEY (id);


--
-- Name: employee_store_history employee_store_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history
    ADD CONSTRAINT employee_store_history_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: expense_categories expense_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_categories
    ADD CONSTRAINT expense_categories_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_expense_no_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_expense_no_unique UNIQUE (expense_no);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: intelligence_reports intelligence_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intelligence_reports
    ADD CONSTRAINT intelligence_reports_pkey PRIMARY KEY (id);


--
-- Name: inventory_daily_snapshots inventory_daily_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_daily_snapshots
    ADD CONSTRAINT inventory_daily_snapshots_pkey PRIMARY KEY (id);


--
-- Name: inventory_daily_snapshots inventory_daily_snapshots_store_id_product_id_date_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_daily_snapshots
    ADD CONSTRAINT inventory_daily_snapshots_store_id_product_id_date_unique UNIQUE (store_id, product_id, date);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: inventory inventory_store_id_product_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_store_id_product_id_unique UNIQUE (store_id, product_id);


--
-- Name: inventory_transactions inventory_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_code_unique UNIQUE (code);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: permissions permissions_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_code_unique UNIQUE (code);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: promotion_items promotion_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_items
    ADD CONSTRAINT promotion_items_pkey PRIMARY KEY (id);


--
-- Name: promotion_reviews promotion_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_reviews
    ADD CONSTRAINT promotion_reviews_pkey PRIMARY KEY (id);


--
-- Name: promotion_rules promotion_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules
    ADD CONSTRAINT promotion_rules_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_order_no_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_order_no_unique UNIQUE (order_no);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: quick_action_items quick_action_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_action_items
    ADD CONSTRAINT quick_action_items_pkey PRIMARY KEY (id);


--
-- Name: quick_actions quick_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_actions
    ADD CONSTRAINT quick_actions_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: resumes resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_organization_id_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organization_id_code_unique UNIQUE (organization_id, code);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: saas_integrations saas_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saas_integrations
    ADD CONSTRAINT saas_integrations_pkey PRIMARY KEY (id);


--
-- Name: salary_records salary_records_employee_id_year_month_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_employee_id_year_month_unique UNIQUE (employee_id, year, month);


--
-- Name: salary_records salary_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_pkey PRIMARY KEY (id);


--
-- Name: sales_daily_summaries sales_daily_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_daily_summaries
    ADD CONSTRAINT sales_daily_summaries_pkey PRIMARY KEY (id);


--
-- Name: sales_daily_summaries sales_daily_summaries_store_id_product_id_sale_date_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_daily_summaries
    ADD CONSTRAINT sales_daily_summaries_store_id_product_id_sale_date_unique UNIQUE (store_id, product_id, sale_date);


--
-- Name: sales_order_items sales_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_order_items
    ADD CONSTRAINT sales_order_items_pkey PRIMARY KEY (id);


--
-- Name: sales_orders sales_orders_order_no_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT sales_orders_order_no_unique UNIQUE (order_no);


--
-- Name: sales_orders sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT sales_orders_pkey PRIMARY KEY (id);


--
-- Name: sales_uploads sales_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_uploads
    ADD CONSTRAINT sales_uploads_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_store_id_employee_id_schedule_date_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_store_id_employee_id_schedule_date_unique UNIQUE (store_id, employee_id, schedule_date);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: supplier_products supplier_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_pkey PRIMARY KEY (id);


--
-- Name: supplier_refund_claim_items supplier_refund_claim_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claim_items
    ADD CONSTRAINT supplier_refund_claim_items_pkey PRIMARY KEY (id);


--
-- Name: supplier_refund_claims supplier_refund_claims_claim_no_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claims
    ADD CONSTRAINT supplier_refund_claims_claim_no_unique UNIQUE (claim_no);


--
-- Name: supplier_refund_claims supplier_refund_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claims
    ADD CONSTRAINT supplier_refund_claims_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: user_store_roles user_store_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: weather_logs weather_logs_date_city_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weather_logs
    ADD CONSTRAINT weather_logs_date_city_unique UNIQUE (date, city);


--
-- Name: weather_logs weather_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weather_logs
    ADD CONSTRAINT weather_logs_pkey PRIMARY KEY (id);


--
-- Name: wework_users wework_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wework_users
    ADD CONSTRAINT wework_users_pkey PRIMARY KEY (id);


--
-- Name: wework_users wework_users_wework_userid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wework_users
    ADD CONSTRAINT wework_users_wework_userid_unique UNIQUE (wework_userid);


--
-- Name: ai_messages_intent_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ai_messages_intent_created_at_index ON public.ai_messages USING btree (intent, created_at);


--
-- Name: ai_messages_session_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ai_messages_session_id_index ON public.ai_messages USING btree (session_id);


--
-- Name: ai_sessions_started_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ai_sessions_started_at_index ON public.ai_sessions USING btree (started_at);


--
-- Name: ai_sessions_store_id_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ai_sessions_store_id_user_id_index ON public.ai_sessions USING btree (store_id, user_id);


--
-- Name: attendance_records_store_id_work_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX attendance_records_store_id_work_date_index ON public.attendance_records USING btree (store_id, work_date);


--
-- Name: chat_logs_agent_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chat_logs_agent_id_index ON public.chat_logs USING btree (agent_id);


--
-- Name: chat_logs_conversation_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chat_logs_conversation_id_index ON public.chat_logs USING btree (conversation_id);


--
-- Name: chat_logs_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX chat_logs_occurred_at_index ON public.chat_logs USING btree (occurred_at);


--
-- Name: competitor_hot_products_competitor_id_identified_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX competitor_hot_products_competitor_id_identified_date_index ON public.competitor_hot_products USING btree (competitor_id, identified_date);


--
-- Name: competitor_price_records_collected_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX competitor_price_records_collected_at_index ON public.competitor_price_records USING btree (collected_at);


--
-- Name: competitor_products_competitor_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX competitor_products_competitor_id_index ON public.competitor_products USING btree (competitor_id);


--
-- Name: competitor_products_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX competitor_products_product_id_index ON public.competitor_products USING btree (product_id);


--
-- Name: competitors_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX competitors_organization_id_status_index ON public.competitors USING btree (organization_id, status);


--
-- Name: cpr_competitor_product_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cpr_competitor_product_date ON public.competitor_price_records USING btree (competitor_id, product_id, collected_at);


--
-- Name: cpr_product_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cpr_product_date ON public.competitor_price_records USING btree (product_id, collected_at);


--
-- Name: custom_report_templates_organization_id_is_shared_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX custom_report_templates_organization_id_is_shared_index ON public.custom_report_templates USING btree (organization_id, is_shared);


--
-- Name: customer_follow_ups_store_id_follow_up_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_follow_ups_store_id_follow_up_at_index ON public.customer_follow_ups USING btree (store_id, follow_up_at);


--
-- Name: customer_follow_ups_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_follow_ups_store_id_index ON public.customer_follow_ups USING btree (store_id);


--
-- Name: customer_order_items_customer_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_order_items_customer_order_id_index ON public.customer_order_items USING btree (customer_order_id);


--
-- Name: customer_orders_customer_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_orders_customer_id_index ON public.customer_orders USING btree (customer_id);


--
-- Name: customer_orders_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_orders_store_id_index ON public.customer_orders USING btree (store_id);


--
-- Name: customer_orders_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_orders_store_id_status_index ON public.customer_orders USING btree (store_id, status);


--
-- Name: customers_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customers_phone_index ON public.customers USING btree (phone);


--
-- Name: customers_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customers_store_id_index ON public.customers USING btree (store_id);


--
-- Name: customers_store_id_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customers_store_id_phone_index ON public.customers USING btree (store_id, phone);


--
-- Name: customers_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customers_store_id_status_index ON public.customers USING btree (store_id, status);


--
-- Name: daily_operation_logs_store_id_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX daily_operation_logs_store_id_date_index ON public.daily_operation_logs USING btree (store_id, date);


--
-- Name: damage_records_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX damage_records_product_id_index ON public.damage_records USING btree (product_id);


--
-- Name: damage_records_purchase_order_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX damage_records_purchase_order_item_id_index ON public.damage_records USING btree (purchase_order_item_id);


--
-- Name: damage_records_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX damage_records_store_id_index ON public.damage_records USING btree (store_id);


--
-- Name: damage_records_supplier_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX damage_records_supplier_id_index ON public.damage_records USING btree (supplier_id);


--
-- Name: dashboard_configs_store_id_scope_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dashboard_configs_store_id_scope_index ON public.dashboard_configs USING btree (store_id, scope);


--
-- Name: dashboard_configs_user_id_is_default_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dashboard_configs_user_id_is_default_index ON public.dashboard_configs USING btree (user_id, is_default);


--
-- Name: employee_store_history_employee_id_effective_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employee_store_history_employee_id_effective_date_index ON public.employee_store_history USING btree (employee_id, effective_date);


--
-- Name: employees_current_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employees_current_store_id_status_index ON public.employees USING btree (current_store_id, status);


--
-- Name: employees_employee_no_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employees_employee_no_index ON public.employees USING btree (employee_no);


--
-- Name: employees_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employees_organization_id_status_index ON public.employees USING btree (organization_id, status);


--
-- Name: employees_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employees_phone_index ON public.employees USING btree (phone);


--
-- Name: expense_categories_organization_id_parent_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX expense_categories_organization_id_parent_id_index ON public.expense_categories USING btree (organization_id, parent_id);


--
-- Name: expenses_category_id_expense_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX expenses_category_id_expense_date_index ON public.expenses USING btree (category_id, expense_date);


--
-- Name: expenses_payment_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX expenses_payment_status_index ON public.expenses USING btree (payment_status);


--
-- Name: expenses_store_id_expense_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX expenses_store_id_expense_date_index ON public.expenses USING btree (store_id, expense_date);


--
-- Name: expenses_supplier_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX expenses_supplier_id_index ON public.expenses USING btree (supplier_id);


--
-- Name: inv_tx_reference; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inv_tx_reference ON public.inventory_transactions USING btree (reference_type, reference_id);


--
-- Name: inv_tx_store_product_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inv_tx_store_product_date ON public.inventory_transactions USING btree (store_id, product_id, created_at);


--
-- Name: inv_tx_store_type_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inv_tx_store_type_date ON public.inventory_transactions USING btree (store_id, transaction_type, created_at);


--
-- Name: inventory_daily_snapshots_store_id_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_daily_snapshots_store_id_date_index ON public.inventory_daily_snapshots USING btree (store_id, date);


--
-- Name: inventory_store_id_current_qty_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_store_id_current_qty_index ON public.inventory USING btree (store_id, current_qty);


--
-- Name: inventory_transactions_expiry_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX inventory_transactions_expiry_date_index ON public.inventory_transactions USING btree (expiry_date);


--
-- Name: ir_org_type_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ir_org_type_period ON public.intelligence_reports USING btree (organization_id, report_type, report_period_start);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: leave_requests_employee_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leave_requests_employee_id_status_index ON public.leave_requests USING btree (employee_id, status);


--
-- Name: leave_requests_store_id_start_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX leave_requests_store_id_start_date_index ON public.leave_requests USING btree (store_id, start_date);


--
-- Name: permissions_module_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX permissions_module_index ON public.permissions USING btree (module);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: product_categories_organization_id_parent_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_categories_organization_id_parent_id_index ON public.product_categories USING btree (organization_id, parent_id);


--
-- Name: products_barcode_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_barcode_index ON public.products USING btree (barcode);


--
-- Name: products_category_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_category_id_index ON public.products USING btree (category_id);


--
-- Name: products_code_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_code_index ON public.products USING btree (code);


--
-- Name: products_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_organization_id_status_index ON public.products USING btree (organization_id, status);


--
-- Name: promotion_items_promotion_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX promotion_items_promotion_id_index ON public.promotion_items USING btree (promotion_id);


--
-- Name: promotion_reviews_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX promotion_reviews_store_id_index ON public.promotion_reviews USING btree (store_id);


--
-- Name: promotion_rules_organization_id_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX promotion_rules_organization_id_is_active_index ON public.promotion_rules USING btree (organization_id, is_active);


--
-- Name: promotions_store_id_started_at_ended_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX promotions_store_id_started_at_ended_at_index ON public.promotions USING btree (store_id, started_at, ended_at);


--
-- Name: promotions_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX promotions_store_id_status_index ON public.promotions USING btree (store_id, status);


--
-- Name: purchase_order_items_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_order_items_product_id_index ON public.purchase_order_items USING btree (product_id);


--
-- Name: purchase_order_items_purchase_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_order_items_purchase_order_id_index ON public.purchase_order_items USING btree (purchase_order_id);


--
-- Name: purchase_orders_expected_delivery_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_orders_expected_delivery_date_index ON public.purchase_orders USING btree (expected_delivery_date);


--
-- Name: purchase_orders_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_orders_store_id_status_index ON public.purchase_orders USING btree (store_id, status);


--
-- Name: purchase_orders_supplier_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX purchase_orders_supplier_id_status_index ON public.purchase_orders USING btree (supplier_id, status);


--
-- Name: quick_action_items_quick_action_id_sort_order_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quick_action_items_quick_action_id_sort_order_index ON public.quick_action_items USING btree (quick_action_id, sort_order);


--
-- Name: quick_actions_store_id_enabled_sort_order_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quick_actions_store_id_enabled_sort_order_index ON public.quick_actions USING btree (store_id, enabled, sort_order);


--
-- Name: regions_organization_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX regions_organization_id_index ON public.regions USING btree (organization_id);


--
-- Name: reports_organization_id_report_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reports_organization_id_report_type_index ON public.reports USING btree (organization_id, report_type);


--
-- Name: reports_store_type_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX reports_store_type_period ON public.reports USING btree (store_id, report_type, period_start);


--
-- Name: resumes_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX resumes_organization_id_status_index ON public.resumes USING btree (organization_id, status);


--
-- Name: saas_integrations_organization_id_platform_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saas_integrations_organization_id_platform_index ON public.saas_integrations USING btree (organization_id, platform);


--
-- Name: saas_integrations_store_id_platform_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saas_integrations_store_id_platform_index ON public.saas_integrations USING btree (store_id, platform);


--
-- Name: salary_records_store_id_year_month_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX salary_records_store_id_year_month_index ON public.salary_records USING btree (store_id, year, month);


--
-- Name: sales_daily_summaries_store_id_sale_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_daily_summaries_store_id_sale_date_index ON public.sales_daily_summaries USING btree (store_id, sale_date);


--
-- Name: sales_order_items_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_order_items_product_id_index ON public.sales_order_items USING btree (product_id);


--
-- Name: sales_order_items_sales_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_order_items_sales_order_id_index ON public.sales_order_items USING btree (sales_order_id);


--
-- Name: sales_orders_cashier_id_sold_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_orders_cashier_id_sold_at_index ON public.sales_orders USING btree (cashier_id, sold_at);


--
-- Name: sales_orders_sold_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_orders_sold_at_index ON public.sales_orders USING btree (sold_at);


--
-- Name: sales_orders_store_id_sold_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_orders_store_id_sold_at_index ON public.sales_orders USING btree (store_id, sold_at);


--
-- Name: sales_uploads_store_id_sale_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_uploads_store_id_sale_date_index ON public.sales_uploads USING btree (store_id, sale_date);


--
-- Name: sales_uploads_store_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sales_uploads_store_id_status_index ON public.sales_uploads USING btree (store_id, status);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: stores_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stores_organization_id_status_index ON public.stores USING btree (organization_id, status);


--
-- Name: stores_region_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX stores_region_id_index ON public.stores USING btree (region_id);


--
-- Name: supplier_products_product_id_is_primary_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_products_product_id_is_primary_index ON public.supplier_products USING btree (product_id, is_primary);


--
-- Name: supplier_products_supplier_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_products_supplier_id_index ON public.supplier_products USING btree (supplier_id);


--
-- Name: supplier_refund_claim_items_claim_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_refund_claim_items_claim_id_index ON public.supplier_refund_claim_items USING btree (claim_id);


--
-- Name: supplier_refund_claim_items_damage_record_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_refund_claim_items_damage_record_id_index ON public.supplier_refund_claim_items USING btree (damage_record_id);


--
-- Name: supplier_refund_claims_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_refund_claims_store_id_index ON public.supplier_refund_claims USING btree (store_id);


--
-- Name: supplier_refund_claims_supplier_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX supplier_refund_claims_supplier_id_index ON public.supplier_refund_claims USING btree (supplier_id);


--
-- Name: suppliers_organization_id_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX suppliers_organization_id_status_index ON public.suppliers USING btree (organization_id, status);


--
-- Name: user_store_roles_store_id_role_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_store_roles_store_id_role_id_index ON public.user_store_roles USING btree (store_id, role_id);


--
-- Name: user_store_roles_user_id_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_store_roles_user_id_store_id_index ON public.user_store_roles USING btree (user_id, store_id);


--
-- Name: weather_logs_store_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX weather_logs_store_id_index ON public.weather_logs USING btree (store_id);


--
-- Name: wework_users_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wework_users_user_id_index ON public.wework_users USING btree (user_id);


--
-- Name: ai_messages ai_messages_session_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_messages
    ADD CONSTRAINT ai_messages_session_id_foreign FOREIGN KEY (session_id) REFERENCES public.ai_sessions(id) ON DELETE CASCADE;


--
-- Name: ai_sessions ai_sessions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: ai_sessions ai_sessions_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_sessions
    ADD CONSTRAINT ai_sessions_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: attendance_records attendance_records_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: attendance_records attendance_records_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: attendance_records attendance_records_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: competitor_hot_products competitor_hot_products_competitor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products
    ADD CONSTRAINT competitor_hot_products_competitor_id_foreign FOREIGN KEY (competitor_id) REFERENCES public.competitors(id) ON DELETE CASCADE;


--
-- Name: competitor_hot_products competitor_hot_products_competitor_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products
    ADD CONSTRAINT competitor_hot_products_competitor_product_id_foreign FOREIGN KEY (competitor_product_id) REFERENCES public.competitor_products(id) ON DELETE CASCADE;


--
-- Name: competitor_hot_products competitor_hot_products_our_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products
    ADD CONSTRAINT competitor_hot_products_our_product_id_foreign FOREIGN KEY (our_product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: competitor_hot_products competitor_hot_products_reviewed_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_hot_products
    ADD CONSTRAINT competitor_hot_products_reviewed_by_foreign FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: competitor_price_records competitor_price_records_collected_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records
    ADD CONSTRAINT competitor_price_records_collected_by_foreign FOREIGN KEY (collected_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: competitor_price_records competitor_price_records_competitor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records
    ADD CONSTRAINT competitor_price_records_competitor_id_foreign FOREIGN KEY (competitor_id) REFERENCES public.competitors(id) ON DELETE CASCADE;


--
-- Name: competitor_price_records competitor_price_records_competitor_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records
    ADD CONSTRAINT competitor_price_records_competitor_product_id_foreign FOREIGN KEY (competitor_product_id) REFERENCES public.competitor_products(id) ON DELETE CASCADE;


--
-- Name: competitor_price_records competitor_price_records_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_price_records
    ADD CONSTRAINT competitor_price_records_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: competitor_products competitor_products_competitor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_products
    ADD CONSTRAINT competitor_products_competitor_id_foreign FOREIGN KEY (competitor_id) REFERENCES public.competitors(id) ON DELETE CASCADE;


--
-- Name: competitor_products competitor_products_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitor_products
    ADD CONSTRAINT competitor_products_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: competitors competitors_nearest_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitors
    ADD CONSTRAINT competitors_nearest_store_id_foreign FOREIGN KEY (nearest_store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: competitors competitors_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competitors
    ADD CONSTRAINT competitors_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: custom_report_templates custom_report_templates_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_report_templates
    ADD CONSTRAINT custom_report_templates_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: custom_report_templates custom_report_templates_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_report_templates
    ADD CONSTRAINT custom_report_templates_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: customer_follow_ups customer_follow_ups_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_follow_ups
    ADD CONSTRAINT customer_follow_ups_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: customer_follow_ups customer_follow_ups_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_follow_ups
    ADD CONSTRAINT customer_follow_ups_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: customer_order_items customer_order_items_customer_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_order_items
    ADD CONSTRAINT customer_order_items_customer_order_id_foreign FOREIGN KEY (customer_order_id) REFERENCES public.customer_orders(id) ON DELETE CASCADE;


--
-- Name: customer_order_items customer_order_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_order_items
    ADD CONSTRAINT customer_order_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE SET NULL;


--
-- Name: customer_orders customer_orders_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE SET NULL;


--
-- Name: customer_orders customer_orders_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: customer_orders customer_orders_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: customers customers_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: customers customers_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: daily_operation_logs daily_operation_logs_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_operation_logs
    ADD CONSTRAINT daily_operation_logs_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: damage_records damage_records_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_records
    ADD CONSTRAINT damage_records_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: damage_records damage_records_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_records
    ADD CONSTRAINT damage_records_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: damage_records damage_records_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.damage_records
    ADD CONSTRAINT damage_records_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: dashboard_configs dashboard_configs_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_configs
    ADD CONSTRAINT dashboard_configs_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: dashboard_configs dashboard_configs_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_configs
    ADD CONSTRAINT dashboard_configs_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: employee_store_history employee_store_history_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history
    ADD CONSTRAINT employee_store_history_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: employee_store_history employee_store_history_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history
    ADD CONSTRAINT employee_store_history_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: employee_store_history employee_store_history_from_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history
    ADD CONSTRAINT employee_store_history_from_store_id_foreign FOREIGN KEY (from_store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: employee_store_history employee_store_history_to_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee_store_history
    ADD CONSTRAINT employee_store_history_to_store_id_foreign FOREIGN KEY (to_store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: employees employees_current_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_current_store_id_foreign FOREIGN KEY (current_store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: employees employees_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: employees employees_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: expense_categories expense_categories_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_categories
    ADD CONSTRAINT expense_categories_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: expense_categories expense_categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_categories
    ADD CONSTRAINT expense_categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.expense_categories(id) ON DELETE SET NULL;


--
-- Name: expenses expenses_ai_session_message_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_ai_session_message_id_foreign FOREIGN KEY (ai_session_message_id) REFERENCES public.ai_messages(id) ON DELETE SET NULL;


--
-- Name: expenses expenses_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: expenses expenses_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.expense_categories(id) ON DELETE CASCADE;


--
-- Name: expenses expenses_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: expenses expenses_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: expenses expenses_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- Name: intelligence_reports intelligence_reports_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intelligence_reports
    ADD CONSTRAINT intelligence_reports_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: intelligence_reports intelligence_reports_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intelligence_reports
    ADD CONSTRAINT intelligence_reports_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: inventory_daily_snapshots inventory_daily_snapshots_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_daily_snapshots
    ADD CONSTRAINT inventory_daily_snapshots_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: inventory_daily_snapshots inventory_daily_snapshots_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_daily_snapshots
    ADD CONSTRAINT inventory_daily_snapshots_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: inventory inventory_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: inventory inventory_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: inventory_transactions inventory_transactions_operator_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_operator_id_foreign FOREIGN KEY (operator_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inventory_transactions inventory_transactions_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: inventory_transactions inventory_transactions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_transactions
    ADD CONSTRAINT inventory_transactions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: leave_requests leave_requests_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: leave_requests leave_requests_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: product_categories product_categories_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: products products_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_foreign FOREIGN KEY (category_id) REFERENCES public.product_categories(id) ON DELETE SET NULL;


--
-- Name: products products_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: products products_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: products products_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- Name: promotion_items promotion_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_items
    ADD CONSTRAINT promotion_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: promotion_items promotion_items_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_items
    ADD CONSTRAINT promotion_items_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotion_reviews promotion_reviews_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_reviews
    ADD CONSTRAINT promotion_reviews_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotions(id) ON DELETE CASCADE;


--
-- Name: promotion_reviews promotion_reviews_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_reviews
    ADD CONSTRAINT promotion_reviews_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: promotion_rules promotion_rules_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotion_rules
    ADD CONSTRAINT promotion_rules_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: promotions promotions_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_rule_id_foreign FOREIGN KEY (rule_id) REFERENCES public.promotion_rules(id) ON DELETE SET NULL;


--
-- Name: promotions promotions_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: purchase_order_items purchase_order_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: purchase_order_items purchase_order_items_purchase_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_foreign FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- Name: purchase_order_items purchase_order_items_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_approved_by_foreign FOREIGN KEY (approved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: purchase_orders purchase_orders_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: quick_action_items quick_action_items_quick_action_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_action_items
    ADD CONSTRAINT quick_action_items_quick_action_id_foreign FOREIGN KEY (quick_action_id) REFERENCES public.quick_actions(id) ON DELETE CASCADE;


--
-- Name: regions regions_manager_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_manager_user_id_foreign FOREIGN KEY (manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: regions regions_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: regions regions_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_parent_id_foreign FOREIGN KEY (parent_id) REFERENCES public.regions(id) ON DELETE SET NULL;


--
-- Name: reports reports_generated_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_generated_by_foreign FOREIGN KEY (generated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports reports_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: reports reports_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE SET NULL;


--
-- Name: resumes resumes_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: resumes resumes_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resumes
    ADD CONSTRAINT resumes_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: roles roles_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- Name: saas_integrations saas_integrations_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saas_integrations
    ADD CONSTRAINT saas_integrations_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: saas_integrations saas_integrations_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saas_integrations
    ADD CONSTRAINT saas_integrations_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: salary_records salary_records_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: salary_records salary_records_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.salary_records
    ADD CONSTRAINT salary_records_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: sales_daily_summaries sales_daily_summaries_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_daily_summaries
    ADD CONSTRAINT sales_daily_summaries_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: sales_daily_summaries sales_daily_summaries_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_daily_summaries
    ADD CONSTRAINT sales_daily_summaries_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: sales_order_items sales_order_items_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_order_items
    ADD CONSTRAINT sales_order_items_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: sales_order_items sales_order_items_sales_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_order_items
    ADD CONSTRAINT sales_order_items_sales_order_id_foreign FOREIGN KEY (sales_order_id) REFERENCES public.sales_orders(id) ON DELETE CASCADE;


--
-- Name: sales_orders sales_orders_cashier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT sales_orders_cashier_id_foreign FOREIGN KEY (cashier_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: sales_orders sales_orders_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT sales_orders_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: sales_uploads sales_uploads_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_uploads
    ADD CONSTRAINT sales_uploads_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: sales_uploads sales_uploads_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_uploads
    ADD CONSTRAINT sales_uploads_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_created_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_created_by_foreign FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: schedules schedules_employee_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_employee_id_foreign FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: stores stores_manager_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_manager_user_id_foreign FOREIGN KEY (manager_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: stores stores_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: stores stores_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE SET NULL;


--
-- Name: supplier_products supplier_products_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: supplier_products supplier_products_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: supplier_refund_claim_items supplier_refund_claim_items_claim_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claim_items
    ADD CONSTRAINT supplier_refund_claim_items_claim_id_foreign FOREIGN KEY (claim_id) REFERENCES public.supplier_refund_claims(id) ON DELETE CASCADE;


--
-- Name: supplier_refund_claim_items supplier_refund_claim_items_damage_record_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claim_items
    ADD CONSTRAINT supplier_refund_claim_items_damage_record_id_foreign FOREIGN KEY (damage_record_id) REFERENCES public.damage_records(id);


--
-- Name: supplier_refund_claims supplier_refund_claims_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claims
    ADD CONSTRAINT supplier_refund_claims_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id);


--
-- Name: supplier_refund_claims supplier_refund_claims_supplier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.supplier_refund_claims
    ADD CONSTRAINT supplier_refund_claims_supplier_id_foreign FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: suppliers suppliers_organization_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_organization_id_foreign FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- Name: user_store_roles user_store_roles_granted_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_granted_by_foreign FOREIGN KEY (granted_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_store_roles user_store_roles_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE SET NULL;


--
-- Name: user_store_roles user_store_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_store_roles user_store_roles_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.stores(id) ON DELETE CASCADE;


--
-- Name: user_store_roles user_store_roles_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_roles
    ADD CONSTRAINT user_store_roles_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: wework_users wework_users_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wework_users
    ADD CONSTRAINT wework_users_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QQt9iG8Zj77BbfoH43GAHkwbxwWz6xK8wVrHoU0MvTF9pUHZKMoMh4FX85q0Ibc

--
-- PostgreSQL database dump
--

\restrict 5Tjm7V5TalBDQCcaziWSTojk9je1gwHGdp8SWTjbsi6j3H35j1gZzMdhbKKsccF

-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2025_11_29_220023_create_personal_access_tokens_table	1
5	2025_11_29_220222_create_posts_table	1
6	2026_03_16_000001_create_organizations_table	1
7	2026_03_16_000002_create_regions_table	1
8	2026_03_16_000003_create_stores_table	1
9	2026_03_16_000004_create_roles_permissions_tables	1
10	2026_03_16_000005_create_saas_integrations_tables	1
11	2026_03_16_000006_create_product_categories_table	1
12	2026_03_16_000007_create_products_tables	1
13	2026_03_16_000008_create_suppliers_tables	1
14	2026_03_16_000009_create_inventory_tables	1
15	2026_03_16_000010_create_ai_assistant_tables	1
16	2026_03_16_000011_create_ai_forecast_tables	1
17	2026_03_16_000012_create_promotion_tables	1
18	2026_03_16_000013_create_competitor_tables	1
19	2026_03_16_000014_create_finance_tables	1
20	2026_03_16_000015_create_hr_tables	1
21	2026_03_16_000016_create_dashboard_report_tables	1
22	2026_03_22_070800_add_is_admin_to_users_table	1
23	2026_03_22_082441_add_supplier_id_to_products_table	1
24	2026_03_22_100000_create_resumes_table	1
25	2026_03_22_111908_alter_purchase_orders_move_supplier_to_items	1
26	2026_03_30_224524_create_sales_orders_tables	1
27	2026_03_30_225348_add_last_sold_out_at_to_inventory_table	1
28	2026_03_30_225639_create_product_sellout_logs_table	1
29	2026_03_30_230102_rename_last_sold_out_at_and_drop_sellout_logs	1
30	2026_03_31_000816_create_inventory_daily_snapshots_table	1
31	2026_03_31_004600_create_daily_operation_logs_table	1
32	2026_03_31_012733_create_sales_daily_summaries_table	1
33	2026_03_31_013104_drop_unused_inventory_sales_tables	1
34	2026_03_31_022259_drop_store_products_table	1
35	2026_03_31_022902_add_sold_out_at_to_inventory_daily_snapshots	1
36	2026_03_31_022902_drop_unused_supplier_finance_tables	1
37	2026_03_31_215717_create_sales_uploads_table	1
38	2026_04_04_022128_add_username_to_users_table	1
39	2026_04_04_025507_add_source_columns_to_sales_daily_summaries	1
40	2026_04_07_000001_create_chat_logs_table	1
41	2026_04_15_214504_add_failure_fields_to_daily_operation_logs	1
42	2026_04_17_000309_create_weather_logs_table	1
43	2026_04_29_070457_create_damage_records_table	1
44	2026_04_29_070458_create_supplier_refund_claims_tables	1
45	2026_05_30_120000_create_quick_actions_tables	1
46	2026_05_30_130000_create_app_settings_table	1
47	2026_05_31_070311_add_image_paths_to_purchase_orders_table	1
48	2026_05_31_093318_create_customers_table	2
49	2026_05_31_093319_create_customer_follow_ups_table	2
50	2026_05_31_093319_create_customer_orders_table	3
51	2026_05_31_093320_create_customer_order_items_table	3
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 51, true);


--
-- PostgreSQL database dump complete
--

\unrestrict 5Tjm7V5TalBDQCcaziWSTojk9je1gwHGdp8SWTjbsi6j3H35j1gZzMdhbKKsccF

