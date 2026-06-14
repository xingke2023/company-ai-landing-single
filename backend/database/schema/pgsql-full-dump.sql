--
-- PostgreSQL database dump
--

\restrict noOc03XCHDOMw2lyP6Qy2L3Gleyd7YRF47OOnap81aqjTfquLqKHJR6Ta3h4ewi

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
-- Name: industries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.industries (
    id bigint NOT NULL,
    slug character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    emoji character varying(16),
    title character varying(100),
    description character varying(200),
    sort_order integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    api_base character varying(200),
    api_token text,
    ai_path character varying(200),
    ai_media boolean DEFAULT false NOT NULL,
    greeting text
);


--
-- Name: COLUMN industries.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.slug IS '行业标识，如 fresh / restaurant；quick_actions.industry 用它过滤';


--
-- Name: COLUMN industries.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.name IS '行业名称，如 生鲜门店';


--
-- Name: COLUMN industries.emoji; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.emoji IS '行业图标 emoji';


--
-- Name: COLUMN industries.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.title IS '该行业聊天页顶栏品牌标题';


--
-- Name: COLUMN industries.description; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.description IS '行业说明（选择页副标题）';


--
-- Name: COLUMN industries.api_base; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.api_base IS '该行业菜单/标题/接口的外部后端 base（如 https://app2.xingke888.com/api）；留空=用本项目';


--
-- Name: COLUMN industries.api_token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.api_token IS '外部行业服务账号 token；随 /api/industries 返回，小程序无需弹登录框直接使用';


--
-- Name: COLUMN industries.ai_path; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.ai_path IS '外部行业 AI 聊天接口路径，如 /api/chat/message；留空默认 /ai/message';


--
-- Name: COLUMN industries.ai_media; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.ai_media IS '该行业聊天是否启用语音/拍照/相册/文件输入';


--
-- Name: COLUMN industries.greeting; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.industries.greeting IS '行业欢迎语（聊天页登录后展示）；留空小程序用通用兜底';


--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.industries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.industries_id_seq OWNED BY public.industries.id;


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
-- Name: menu_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.menu_templates (
    id bigint NOT NULL,
    industry character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- Name: COLUMN menu_templates.industry; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.menu_templates.industry IS '归属行业 slug（关联 industries.slug）';


--
-- Name: COLUMN menu_templates.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.menu_templates.name IS '模版名，如 默认模版 / 完整版 / 促销版';


--
-- Name: COLUMN menu_templates.is_active; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.menu_templates.is_active IS '该行业当前生效的模版（每行业仅一个 true）';


--
-- Name: menu_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.menu_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.menu_templates_id_seq OWNED BY public.menu_templates.id;


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
    updated_at timestamp(0) without time zone,
    industry character varying(50),
    menu_template_id bigint
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
-- Name: COLUMN quick_actions.industry; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.quick_actions.industry IS '所属行业 slug（关联 industries.slug）；null=全行业通用';


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
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries ALTER COLUMN id SET DEFAULT nextval('public.industries_id_seq'::regclass);


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
-- Name: menu_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_templates ALTER COLUMN id SET DEFAULT nextval('public.menu_templates_id_seq'::regclass);


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
-- Data for Name: ai_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_messages (id, session_id, role, input_type, raw_content, voice_url, image_urls, transcribed_text, ocr_text, ai_response, intent, entities, confidence, dispatched_module, dispatched_action_id, processing_time_ms, created_at) FROM stdin;
1	1	1	1	测试连接	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-22 06:59:53
2	1	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	167	2026-03-22 06:59:53
3	2	1	1	今天下午到货了50斤苹果，请帮我录入库存	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 04:22:14
4	2	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	128	2026-03-31 04:22:14
5	3	1	1	今天下午有50斤苹果到货了	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 04:22:18
6	3	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	64	2026-03-31 04:22:18
7	4	1	1	今天下午有50斤苹果到货了	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 04:22:38
8	4	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	61	2026-03-31 04:22:38
9	5	1	1	猪五花肉卖掉10斤	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 04:43:14
10	5	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	77	2026-03-31 04:43:14
11	6	1	1	今天苹果到货50斤	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 05:22:10
12	6	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	99	2026-03-31 05:22:10
13	7	1	1	卖了5斤番茄	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 05:27:34
14	7	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	70	2026-03-31 05:27:34
15	8	1	1	苹果卖完了	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 05:43:45
16	8	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	84	2026-03-31 05:43:45
17	9	1	1	现在，番茄卖得很慢	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-03-31 08:49:04
18	9	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	94	2026-03-31 08:49:04
19	10	1	1		\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-01 07:38:14
20	10	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	65	2026-04-01 07:38:14
21	11	1	1	今天到货：野生苹果1件、小台芒1件、耙耙柑2件、香蕉1件、牛奶蕉1件、赣南脐橙1件、散装枇杷2件、精品草莓2件、袋装金桔2件、油柑1件、小青橘0.5件、带叶沃柑1件、菠萝1件、大木瓜1件	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-01 08:41:59
22	11	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	63	2026-04-01 08:41:59
23	12	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-26 18:30:32
24	12	2	1	\N	\N	\N	\N	\N	你好！有什么可以帮助你的吗？	\N	\N	\N	inventory	\N	974	2026-04-26 18:30:32
25	12	1	1	今天天气怎么样	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-26 18:30:39
26	12	2	1	\N	\N	\N	\N	\N	已记录您的日常汇报，但未涉及库存信息。	\N	\N	\N	inventory	\N	906	2026-04-26 18:30:39
27	13	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-26 19:25:47
28	13	2	1	\N	\N	\N	\N	\N	你好！有什么可以帮助您的？	\N	\N	\N	inventory	\N	819	2026-04-26 19:25:47
29	13	1	1	今天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-04-26 19:25:54
30	13	2	1	\N	\N	\N	\N	\N	☀️ 今天香港天气晴，26-32°C，湿度65%，降雨概率10%。天气炎热，注意生鲜冷藏，客流预计正常。	\N	\N	\N	inventory	\N	1355	2026-04-26 19:25:54
31	13	1	1	今天进货多少	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-26 19:26:03
32	13	2	1	\N	\N	\N	\N	\N	请提供具体的进货商品和数量，例如“收到50斤胡萝卜”。	\N	\N	\N	inventory	\N	1099	2026-04-26 19:26:03
33	13	1	1	今天进货情况是怎么样的	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-26 19:26:16
34	13	2	1	\N	\N	\N	\N	\N	您还没有提供具体的进货信息，请告诉我收到了哪些商品和数量，例如“收到50斤胡萝卜”。	\N	\N	\N	inventory	\N	1082	2026-04-26 19:26:16
35	14	1	1	胡萝卜卖了10斤	\N	\N	\N	\N	\N	sale_report	[{"qty": 10, "unit": "斤", "action": "sell", "product_name": "胡萝卜"}]	\N	\N	\N	\N	2026-04-27 20:58:36
36	14	2	1	\N	\N	\N	\N	\N	已记录胡萝卜售出10斤。	\N	\N	\N	inventory	\N	1321	2026-04-27 20:58:36
37	15	1	1	胡萝卜卖了10斤	\N	\N	\N	\N	\N	sale_report	[{"qty": 10, "unit": "斤", "action": "sell", "product_name": "胡萝卜"}]	\N	\N	\N	\N	2026-04-27 21:28:44
38	15	2	1	\N	\N	\N	\N	\N	已记录胡萝卜售出10斤。	\N	\N	\N	inventory	\N	1339	2026-04-27 21:28:45
39	16	1	1	番茄卖了10斤	\N	\N	\N	\N	\N	sale_report	[{"qty": 10, "unit": "斤", "action": "sell", "product_name": "番茄"}]	\N	\N	\N	\N	2026-04-27 21:56:48
40	16	2	1	\N	\N	\N	\N	\N	已记录番茄售出10斤。	\N	\N	\N	inventory	\N	1465	2026-04-27 21:56:48
41	17	1	4	这是什么	\N	["[base64 image]"]	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-27 21:56:58
42	17	2	1	\N	\N	\N	\N	\N	这是一张纯绿色的图片，请问有什么我可以帮您的吗？	\N	\N	\N	inventory	\N	5556	2026-04-27 21:56:58
43	18	1	1	你現在在哪裡呀	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-27 22:05:18
44	18	2	1	\N	\N	\N	\N	\N	我是您的AI助手，没有实体位置哦。	\N	\N	\N	inventory	\N	986	2026-04-27 22:05:18
45	19	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-27 22:22:40
46	19	2	1	\N	\N	\N	\N	\N	你好！请问有什么可以帮您？	\N	\N	\N	inventory	\N	3063	2026-04-27 22:22:40
47	20	1	1	白菜 又卖了22.6斤	\N	\N	\N	\N	\N	sale_report	[{"qty": 22.6, "unit": "斤", "action": "sell", "product_name": "白菜"}]	\N	\N	\N	\N	2026-04-27 22:26:23
48	20	2	1	\N	\N	\N	\N	\N	已记录卖出22.6斤白菜。	\N	\N	\N	inventory	\N	5717	2026-04-27 22:26:23
49	21	1	1	你好 你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-27 22:58:49
50	21	2	1	\N	\N	\N	\N	\N	我是舌尖香港AI助手，随时为您服务。	\N	\N	\N	inventory	\N	4611	2026-04-27 22:58:49
51	22	1	1	今日草莓半斤坏果	\N	\N	\N	\N	\N	waste_report	[{"qty": 0.5, "unit": "斤", "action": "out", "product_name": "草莓"}]	\N	\N	\N	\N	2026-04-28 13:08:01
52	22	2	1	\N	\N	\N	\N	\N	已记录草莓损耗半斤。	\N	\N	\N	inventory	\N	11727	2026-04-28 13:08:01
53	22	1	1	给我一个进货建议	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-28 13:14:29
54	22	2	1	\N	\N	\N	\N	\N	抱歉，我目前无法提供进货建议，请提供具体数据或使用其他功能。	\N	\N	\N	inventory	\N	6531	2026-04-28 13:14:29
55	22	1	1	苹果还剩20斤，有什么建议？	\N	\N	\N	\N	\N	remaining	[{"qty": 20, "unit": "斤", "action": "remaining", "product_name": "苹果"}]	\N	\N	\N	\N	2026-04-28 13:31:17
56	22	2	1	\N	\N	\N	\N	\N	已记录苹果剩余20斤。建议根据销售情况及时补货或安排促销。	\N	\N	\N	inventory	\N	10949	2026-04-28 13:31:17
57	23	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-04-29 07:51:01
58	23	2	1	\N	\N	\N	\N	\N	你好，有什么可以帮您？	\N	\N	\N	inventory	\N	3151	2026-04-29 07:51:01
59	24	1	1	苹果卖完了	\N	\N	\N	\N	\N	sold_out	[{"qty": 0, "unit": "斤", "action": "sold_out", "product_name": "苹果"}]	\N	\N	\N	\N	2026-04-29 08:19:43
60	24	2	1	\N	\N	\N	\N	\N	已记录苹果卖完了	\N	\N	\N	inventory	\N	5094	2026-04-29 08:19:43
61	25	1	1	上传进货单	\N	\N	\N	\N	\N	purchase_receipt	[{"qty": 50, "unit": "斤", "action": "in", "product_name": "番茄"}, {"qty": 30, "unit": "斤", "action": "in", "product_name": "胡萝卜"}]	\N	\N	\N	\N	2026-05-11 05:30:37
164	54	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2400	2026-05-30 08:12:00
62	25	2	1	\N	\N	\N	\N	\N	我识别到这是一张进货单，共2种商品：番茄50斤、胡萝卜30斤。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	7697	2026-05-11 05:30:37
63	25	1	1	上传了什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-11 05:31:00
64	25	2	1	\N	\N	\N	\N	\N	您尚未上传图片	\N	\N	\N	inventory	\N	7869	2026-05-11 05:31:00
65	25	1	1	你現在在哪裡呀	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-11 05:34:08
66	25	2	1	\N	\N	\N	\N	\N	我是您的线上门店助手，随时在这里为您服务哦！	\N	\N	\N	inventory	\N	6206	2026-05-11 05:34:08
67	26	1	3		\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 50, "unit": "斤", "action": "in", "product_name": "番茄"}, {"qty": 30, "unit": "斤", "action": "in", "product_name": "胡萝卜"}]	\N	\N	\N	\N	2026-05-11 05:36:12
68	26	2	1	\N	\N	\N	\N	\N	我识别到这是一张进货记录，共2种商品：番茄50斤、胡萝卜30斤。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	5976	2026-05-11 05:36:12
69	27	1	1	天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-11 05:39:43
70	27	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3345	2026-05-11 05:39:43
71	28	1	3		\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 50, "unit": "斤", "action": "in", "product_name": "番茄"}, {"qty": 30, "unit": "斤", "action": "in", "product_name": "胡萝卜"}]	\N	\N	\N	\N	2026-05-11 05:41:39
72	28	2	1	\N	\N	\N	\N	\N	我识别到这是一张进货单，共2种商品：番茄50斤、胡萝卜30斤。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	5349	2026-05-11 05:41:39
73	29	1	1	今日进了什么火	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-11 05:50:16
74	29	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	5528	2026-05-11 05:50:16
75	29	1	1	今天的进货单可以看看吗	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-11 05:50:56
76	29	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	29825	2026-05-11 05:50:56
77	29	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-11 05:55:24
78	29	2	1	\N	\N	\N	\N	\N	我是您的生鲜门店AI助手，就在您身边。	\N	\N	\N	inventory	\N	3710	2026-05-11 05:55:24
79	30	1	1	进了10斤橙子	\N	\N	\N	\N	\N	purchase_receipt	[{"qty": 10, "unit": "斤", "action": "in", "reason": "", "product_name": "橙子"}]	\N	\N	\N	\N	2026-05-11 07:21:55
80	30	2	1	\N	\N	\N	\N	\N	已记录进货10斤橙子	\N	\N	\N	inventory	\N	6675	2026-05-11 07:21:55
81	31	1	1	有10斤白菜坏了	\N	\N	\N	\N	\N	waste_report	[{"qty": 10, "unit": "斤", "action": "out", "reason": "变质", "product_name": "白菜"}]	\N	\N	\N	\N	2026-05-11 07:24:16
82	31	2	1	\N	\N	\N	\N	\N	已记录白菜损耗10斤	\N	\N	\N	inventory	\N	6354	2026-05-11 07:24:16
83	32	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-11 07:53:50
84	32	2	1	\N	\N	\N	\N	\N	我是舌尖香港AI助手	\N	\N	\N	inventory	\N	4204	2026-05-11 07:53:50
85	33	1	1	苹果损耗1斤	\N	\N	\N	\N	\N	waste_report	[{"qty": 1, "unit": "斤", "action": "out", "reason": "变质", "product_name": "苹果"}]	\N	\N	\N	\N	2026-05-11 19:51:10
86	33	2	1	\N	\N	\N	\N	\N	已记录苹果损耗1斤	\N	\N	\N	inventory	\N	6304	2026-05-11 19:51:10
87	34	1	1	苹果损耗一斤	\N	\N	\N	\N	\N	waste_report	[{"qty": 1, "unit": "斤", "action": "out", "reason": "变质", "product_name": "苹果"}]	\N	\N	\N	\N	2026-05-11 19:51:22
88	34	2	1	\N	\N	\N	\N	\N	已记录苹果损耗1斤	\N	\N	\N	inventory	\N	5366	2026-05-11 19:51:22
89	35	1	1	今天到货10斤胡萝卜，30斤猕猴桃	\N	\N	\N	\N	\N	purchase_receipt	[{"qty": 10, "unit": "斤", "action": "in", "product_name": "胡萝卜"}, {"qty": 30, "unit": "斤", "action": "in", "product_name": "猕猴桃"}]	\N	\N	\N	\N	2026-05-11 20:00:58
90	35	2	1	\N	\N	\N	\N	\N	已录入到货：胡萝卜10斤、猕猴桃30斤。	\N	\N	\N	inventory	\N	7096	2026-05-11 20:00:58
91	35	1	1	到货香蕉有2斤烂的	\N	\N	\N	\N	\N	waste_report	[{"qty": 2, "unit": "斤", "action": "out", "reason": "变质", "product_name": "香蕉"}]	\N	\N	\N	\N	2026-05-11 20:01:53
92	35	2	1	\N	\N	\N	\N	\N	已记录香蕉损耗2斤（变质）	\N	\N	\N	inventory	\N	6077	2026-05-11 20:01:53
93	36	1	1	今天苹果3点就卖完了	\N	\N	\N	\N	\N	sold_out	[{"qty": 0, "unit": "斤", "action": "sold_out", "product_name": "苹果"}]	\N	\N	\N	\N	2026-05-11 20:28:44
94	36	2	1	\N	\N	\N	\N	\N	已记录苹果售罄	\N	\N	\N	inventory	\N	16511	2026-05-11 20:28:44
95	37	1	1	今天橙子三点多就卖完了	\N	\N	\N	\N	\N	sold_out	[{"qty": 0, "unit": "斤", "action": "sold_out", "reason": "", "product_name": "橙子"}]	\N	\N	\N	\N	2026-05-11 20:29:08
96	37	2	1	\N	\N	\N	\N	\N	已记录橙子卖完	\N	\N	\N	inventory	\N	8035	2026-05-11 20:29:08
97	38	1	4	坏货记录	\N	["[base64 image]"]	\N	\N	\N	waste_report	[{"qty": 1.095, "unit": "斤", "action": "out", "reason": "变质", "product_name": "枇杷"}, {"qty": 1, "unit": "袋", "action": "out", "reason": "变质", "product_name": "辣椒叶300g"}, {"qty": 1, "unit": "袋", "action": "out", "reason": "变质", "product_name": "地瓜叶300g"}, {"qty": 2.274, "unit": "斤", "action": "out", "reason": "变质", "product_name": "西兰花"}, {"qty": 1, "unit": "袋", "action": "out", "reason": "变质", "product_name": "黄豆芽300g"}, {"qty": 5.982, "unit": "袋", "action": "out", "reason": "变质", "product_name": "番茄(粉)350g"}, {"qty": 1, "unit": "个", "action": "out", "reason": "变质", "product_name": "玉露香梨"}]	\N	\N	\N	\N	2026-05-11 21:02:17
98	38	2	1	\N	\N	\N	\N	\N	我识别到这是一张坏货记录单，共包含枇杷、辣椒叶、地瓜叶、西兰花、黄豆芽、番茄和玉露香梨。已为您录入损耗，如有出入请告知。	\N	\N	\N	inventory	\N	15020	2026-05-11 21:02:17
99	38	1	4	枇杷坏货	\N	["[base64 image]"]	\N	\N	\N	waste_report	[{"qty": 1.41, "unit": "斤", "action": "out", "reason": "变质", "product_name": "枇杷"}]	\N	\N	\N	\N	2026-05-11 21:03:03
100	38	2	1	\N	\N	\N	\N	\N	识别到您称重的枇杷损耗为1.41斤，原因为变质。已为您录入损耗，如有出入请告知。	\N	\N	\N	inventory	\N	7687	2026-05-11 21:03:03
101	39	1	4	入库	\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 2, "unit": "盒", "action": "in", "product_name": "上海麵350g"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "蝦米腸粉"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "白腸粉"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "油麵350g"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "雲吞麵 (幼) 350g"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "雲吞麵 (粗) 350g"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "河粉 (炒粉) 350g"}]	\N	\N	\N	\N	2026-05-11 21:04:20
102	39	2	1	\N	\N	\N	\N	\N	我识别到这是一张5月11日的进货单，共7种商品：上海面、虾米肠粉、白肠粉、油面、云吞面(幼/粗)及河粉各2盒。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	8480	2026-05-11 21:04:20
103	39	1	4	入库	\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 1, "unit": "件", "action": "in", "product_name": "牛油果"}, {"qty": 1, "unit": "件", "action": "in", "product_name": "榴莲番薯"}, {"qty": 1, "unit": "件", "action": "in", "product_name": "枇杷"}, {"qty": 3, "unit": "件", "action": "in", "product_name": "奇异果"}, {"qty": 2, "unit": "件", "action": "in", "product_name": "番石榴"}]	\N	\N	\N	\N	2026-05-11 21:04:51
165	54	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:12:53
104	39	2	1	\N	\N	\N	\N	\N	我识别到这是一张进货单，共5种商品：牛油果1件、榴莲番薯1件、枇杷1件、奇异果3件、番石榴2件。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	7436	2026-05-11 21:04:51
105	40	1	1	本周四至周六有雨，请提前提醒下单减量	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-11 21:08:30
106	40	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	5710	2026-05-11 21:08:30
107	41	1	1	有什么应季的水果吗	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-05-11 21:26:18
108	41	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3574	2026-05-11 21:26:18
109	42	1	4	进货单	\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 6, "unit": "只", "action": "in", "product_name": "冰鲜清远鸡"}, {"qty": 5, "unit": "只", "action": "in", "product_name": "冰鲜竹丝鸡"}]	\N	\N	\N	\N	2026-05-11 21:35:31
110	42	2	1	\N	\N	\N	\N	\N	我识别到这是一张5月13日的进货单，共2种商品：冰鲜清远鸡6只、冰鲜竹丝鸡5只。已为您录入，如有出入请告知。	\N	\N	\N	inventory	\N	11048	2026-05-11 21:35:31
111	43	1	4	蔬菜进货单	\N	["[base64 image]"]	\N	\N	\N	purchase_receipt	[{"qty": 8, "unit": "包", "action": "in", "product_name": "娃娃菜"}, {"qty": 5, "unit": "斤", "action": "in", "product_name": "大白菜"}, {"qty": 8, "unit": "斤", "action": "in", "product_name": "小旺菜"}, {"qty": 12, "unit": "斤", "action": "in", "product_name": "京包"}, {"qty": 6, "unit": "斤", "action": "in", "product_name": "椰菜花"}, {"qty": 15, "unit": "斤", "action": "in", "product_name": "西蘭花"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "水東芥菜"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "青通"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "上海青苗"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "菜心"}, {"qty": 20, "unit": "斤", "action": "in", "product_name": "冬瓜"}, {"qty": 5, "unit": "斤", "action": "in", "product_name": "苦瓜"}, {"qty": 6, "unit": "斤", "action": "in", "product_name": "南瓜"}, {"qty": 3, "unit": "斤", "action": "in", "product_name": "西葫蘆瓜"}, {"qty": 6, "unit": "斤", "action": "in", "product_name": "茄子"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "長水瓜"}, {"qty": 8, "unit": "包", "action": "in", "product_name": "甜玉米"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "白白菜"}, {"qty": 2, "unit": "碟", "action": "in", "product_name": "荷蘭豆"}, {"qty": 2, "unit": "碟", "action": "in", "product_name": "板栗肉"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "甜豆(盒)"}, {"qty": 4, "unit": "斤", "action": "in", "product_name": "甜豆"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "青蘿蔔"}, {"qty": 5, "unit": "斤", "action": "in", "product_name": "白蘿蔔"}, {"qty": 10, "unit": "斤", "action": "in", "product_name": "泥紅蘿蔔"}, {"qty": 12, "unit": "斤", "action": "in", "product_name": "紅蘿蔔"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "紅菜頭"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "鮮鐵棍淮山"}, {"qty": 7, "unit": "斤", "action": "in", "product_name": "馬鈴薯"}, {"qty": 3, "unit": "斤", "action": "in", "product_name": "芋頭"}, {"qty": 8, "unit": "盒", "action": "in", "product_name": "綠豆芽"}, {"qty": 6, "unit": "盒", "action": "in", "product_name": "黃豆芽"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "鮮黑木耳"}, {"qty": 5, "unit": "碟", "action": "in", "product_name": "白蘑菇"}, {"qty": 5, "unit": "碟", "action": "in", "product_name": "木耳"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "螺絲椒"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "湖南椒"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "大蔥"}, {"qty": 7, "unit": "斤", "action": "in", "product_name": "西芹"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "韭王"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "韭菜"}, {"qty": 5, "unit": "斤", "action": "in", "product_name": "白洋蔥"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "紅洋蔥"}, {"qty": 4, "unit": "盒", "action": "in", "product_name": "沙律菜"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "杭白菜"}, {"qty": 10, "unit": "包", "action": "in", "product_name": "菠菜"}, {"qty": 4, "unit": "包", "action": "in", "product_name": "枸杞葉"}, {"qty": 3, "unit": "斤", "action": "in", "product_name": "毛瓜"}, {"qty": 5, "unit": "斤", "action": "in", "product_name": "青瓜"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "黃秋葵"}, {"qty": 3, "unit": "斤", "action": "in", "product_name": "蓮藕"}, {"qty": 5, "unit": "袋", "action": "in", "product_name": "小土豆"}, {"qty": 2, "unit": "袋", "action": "in", "product_name": "芋仔"}, {"qty": 3, "unit": "包", "action": "in", "product_name": "金針菇"}, {"qty": 5, "unit": "碟", "action": "in", "product_name": "冬菇"}, {"qty": 3, "unit": "盒", "action": "in", "product_name": "杏鮑菇"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "蟹味菇"}, {"qty": 3, "unit": "盒", "action": "in", "product_name": "白玉菇"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "水果椒"}, {"qty": 2, "unit": "盒", "action": "in", "product_name": "指天椒"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "三色彩椒"}, {"qty": 2, "unit": "袋", "action": "in", "product_name": "生薑"}, {"qty": 3, "unit": "袋", "action": "in", "product_name": "蒜頭"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "芹菜"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "紅蔥"}, {"qty": 5, "unit": "包", "action": "in", "product_name": "芫茜"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "真空淮山肉"}, {"qty": 2, "unit": "碟", "action": "in", "product_name": "秀珍菇"}, {"qty": 2, "unit": "斤", "action": "in", "product_name": "萵筍"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "雞毛菜"}, {"qty": 4, "unit": "包", "action": "in", "product_name": "百合四頭"}, {"qty": 3, "unit": "碟", "action": "in", "product_name": "毛豆仁"}, {"qty": 2, "unit": "碟", "action": "in", "product_name": "豌豆仁"}, {"qty": 2, "unit": "个", "action": "in", "product_name": "青木瓜"}, {"qty": 2, "unit": "包", "action": "in", "product_name": "人參白薯"}]	\N	\N	\N	\N	2026-05-11 21:38:53
112	43	2	1	\N	\N	\N	\N	\N	识别到5月13日的蔬菜进货单，共识别到75项商品，包括娃娃菜、大白菜、冬瓜、西兰花等。已为您录入进货记录，如有出入请告知。	\N	\N	\N	inventory	\N	35877	2026-05-11 21:38:53
113	43	1	1	把所有草莓的情况给我展示一下	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-11 21:48:42
114	43	2	1	\N	\N	\N	\N	\N	正在为您查询草莓的库存情况…	\N	\N	\N	inventory	\N	5091	2026-05-11 21:48:42
115	44	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 07:03:32
116	44	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4099	2026-05-30 07:03:32
117	45	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 07:03:35
118	45	2	1	\N	\N	\N	\N	\N	你好，有什么可以帮您？	\N	\N	\N	inventory	\N	2570	2026-05-30 07:03:35
119	46	1	1	今日销售	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 07:06:44
120	46	2	1	\N	\N	\N	\N	\N	正在为您查询今日销售…	\N	\N	\N	inventory	\N	4543	2026-05-30 07:06:44
121	47	1	1	进货建议	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-05-30 07:06:47
122	47	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3210	2026-05-30 07:06:47
123	48	1	1	每日营运概览	\N	\N	\N	\N	\N	daily_overview_query	[]	\N	\N	\N	\N	2026-05-30 07:06:51
124	48	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3347	2026-05-30 07:06:51
125	49	1	1	明天天气	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 07:06:56
126	49	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	5142	2026-05-30 07:06:56
127	50	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 07:12:19
128	50	2	1	\N	\N	\N	\N	\N	你好！我是舌尖香港AI助手，请问有什么可以帮您？	\N	\N	\N	inventory	\N	4658	2026-05-30 07:12:19
129	50	1	1	看一下今天的每日营运概览	\N	\N	\N	\N	\N	daily_overview_query	[]	\N	\N	\N	\N	2026-05-30 07:12:46
130	50	2	1	\N	\N	\N	\N	\N	正在为您查询今日每日营运概览…	\N	\N	\N	inventory	\N	5472	2026-05-30 07:12:46
131	50	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 07:12:59
132	50	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	10307	2026-05-30 07:12:59
133	50	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 07:13:09
134	50	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	4441	2026-05-30 07:13:09
135	50	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 07:17:02
136	50	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	2749	2026-05-30 07:17:02
137	51	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 07:44:50
138	51	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	5911	2026-05-30 07:44:50
139	52	1	1	123	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 07:59:31
140	52	2	1	\N	\N	\N	\N	\N	抱歉，未能识别您的意图，请重新描述。	\N	\N	\N	inventory	\N	4971	2026-05-30 07:59:31
141	52	1	1	天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 07:59:59
142	52	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2856	2026-05-30 07:59:59
143	53	1	1	好的	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:08:35
144	53	2	1	\N	\N	\N	\N	\N	请说明具体需求	\N	\N	\N	inventory	\N	2311	2026-05-30 08:08:35
145	53	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 08:09:03
146	53	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	6285	2026-05-30 08:09:03
147	53	1	1	你叫什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:09:20
148	53	2	1	\N	\N	\N	\N	\N	我是舌尖香港生鲜门店AI助手。	\N	\N	\N	inventory	\N	2271	2026-05-30 08:09:20
149	53	1	1	补录	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:09:31
150	53	2	1	\N	\N	\N	\N	\N	请说明要补录的内容，例如进货、销售或损耗。	\N	\N	\N	inventory	\N	6388	2026-05-30 08:09:31
151	53	1	1	苹果的销量如何	\N	\N	\N	\N	\N	product_query	[{"product_name": "苹果"}]	\N	\N	\N	\N	2026-05-30 08:09:41
152	53	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2379	2026-05-30 08:09:41
153	53	1	1	后端	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:09:56
154	53	2	1	\N	\N	\N	\N	\N	抱歉，我不理解您的意思。	\N	\N	\N	inventory	\N	3637	2026-05-30 08:09:56
155	53	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:10:38
156	53	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3508	2026-05-30 08:10:38
157	53	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:10:44
158	53	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4376	2026-05-30 08:10:44
159	53	1	1	奇异果卖了一件	\N	\N	\N	\N	\N	sale_report	[{"qty": 1, "unit": "件", "action": "sell", "product_name": "奇异果"}]	\N	\N	\N	\N	2026-05-30 08:10:59
160	53	2	1	\N	\N	\N	\N	\N	已记录奇异果销售1件。	\N	\N	\N	inventory	\N	2811	2026-05-30 08:10:59
161	53	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:11:06
162	53	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3204	2026-05-30 08:11:06
163	54	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:12:00
166	54	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	7844	2026-05-30 08:12:53
167	55	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 08:16:59
168	55	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3713	2026-05-30 08:16:59
169	55	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:17:04
170	55	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3320	2026-05-30 08:17:04
171	55	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:17:39
172	55	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8602	2026-05-30 08:17:39
173	55	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:18:30
174	55	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2799	2026-05-30 08:18:30
175	55	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:19:00
176	55	2	1	\N	\N	\N	\N	\N	你好！请问有什么可以帮您？	\N	\N	\N	inventory	\N	2231	2026-05-30 08:19:00
177	55	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:24:31
178	55	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3123	2026-05-30 08:24:31
179	56	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:28:36
180	56	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4962	2026-05-30 08:28:36
181	55	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:28:59
182	55	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2887	2026-05-30 08:28:59
183	57	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:29:20
184	57	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8248	2026-05-30 08:29:20
185	57	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:29:26
186	57	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2990	2026-05-30 08:29:26
187	56	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:29:50
188	56	2	1	\N	\N	\N	\N	\N	正在为您查询今日销售情况…	\N	\N	\N	inventory	\N	11137	2026-05-30 08:29:50
189	56	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:31:16
190	56	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	11675	2026-05-30 08:31:16
191	56	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:31:43
192	56	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8247	2026-05-30 08:31:43
193	56	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:32:12
194	56	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	6654	2026-05-30 08:32:12
195	58	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:40:42
196	58	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4113	2026-05-30 08:40:42
197	58	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 08:41:11
198	58	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8420	2026-05-30 08:41:11
199	59	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:42:53
200	59	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	8353	2026-05-30 08:42:53
201	60	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:47:36
202	60	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3264	2026-05-30 08:47:36
203	61	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:47:56
204	61	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	6185	2026-05-30 08:47:56
205	61	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 08:48:13
206	61	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3004	2026-05-30 08:48:13
207	61	1	1	看一下今天的操作日志	\N	\N	\N	\N	\N	daily_logs_query	[]	\N	\N	\N	\N	2026-05-30 08:48:36
208	61	2	1	\N	\N	\N	\N	\N	正在为您查询今天的操作日志…	\N	\N	\N	inventory	\N	20464	2026-05-30 08:48:36
209	60	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 08:53:01
210	60	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3489	2026-05-30 08:53:01
211	60	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 08:53:07
212	60	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3171	2026-05-30 08:53:07
213	61	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 08:54:01
214	61	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2761	2026-05-30 08:54:01
215	61	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:54:11
216	61	2	1	\N	\N	\N	\N	\N	我是您的生鲜门店AI助手，专注于进货、销售、库存等管理。	\N	\N	\N	inventory	\N	4375	2026-05-30 08:54:11
217	62	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:58:41
218	62	2	1	\N	\N	\N	\N	\N	你好！有什么可以帮您？	\N	\N	\N	inventory	\N	3254	2026-05-30 08:58:41
219	63	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 08:59:38
220	63	2	1	\N	\N	\N	\N	\N	你好！我是舌尖香港AI助手，请问有什么可以帮您？	\N	\N	\N	inventory	\N	3195	2026-05-30 08:59:38
221	64	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 09:00:22
222	64	2	1	\N	\N	\N	\N	\N	我是您的生鲜门店AI助手舌尖香港，专注于协助您管理门店运营。	\N	\N	\N	inventory	\N	4467	2026-05-30 09:00:22
223	64	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 09:00:33
224	64	2	1	\N	\N	\N	\N	\N	正在为您查询今日销售数据…	\N	\N	\N	inventory	\N	9441	2026-05-30 09:00:33
225	64	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 09:02:33
226	64	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，正在线上为您服务。	\N	\N	\N	inventory	\N	3197	2026-05-30 09:02:33
227	64	1	1	1+15等于多少	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 09:02:43
228	64	2	1	\N	\N	\N	\N	\N	1+15等于16。	\N	\N	\N	inventory	\N	2422	2026-05-30 09:02:43
229	65	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:09:58
230	65	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4002	2026-05-30 09:09:58
231	65	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 09:10:33
232	65	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3543	2026-05-30 09:10:33
233	65	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 09:10:40
234	65	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手（舌尖香港），可以协助您记录进货、销售、损耗、盘点等门店运营操作，也可查询库存、营业数据、天气、进货建议等信息。	\N	\N	\N	inventory	\N	2985	2026-05-30 09:10:40
235	65	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 09:10:46
236	65	2	1	\N	\N	\N	\N	\N	正在为您查询今日销售情况…	\N	\N	\N	inventory	\N	3639	2026-05-30 09:10:46
237	66	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:27:17
238	66	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3014	2026-05-30 09:27:17
239	66	1	1	看一下今天的操作日志	\N	\N	\N	\N	\N	daily_logs_query	[]	\N	\N	\N	\N	2026-05-30 09:27:44
240	66	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	9475	2026-05-30 09:27:44
241	66	1	1	给我一些进货和促销建议	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-05-30 09:27:58
242	66	2	1	\N	\N	\N	\N	\N	正在为您查询进货和促销建议…	\N	\N	\N	inventory	\N	2870	2026-05-30 09:27:58
243	66	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 09:28:09
244	66	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2161	2026-05-30 09:28:09
245	66	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 09:28:20
246	66	2	1	\N	\N	\N	\N	\N	我是您的生鲜门店AI助手，可以帮您记录进货、销售、损耗，查询库存、每日报表等。	\N	\N	\N	inventory	\N	3460	2026-05-30 09:28:20
247	67	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:42:43
248	67	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	19353	2026-05-30 09:42:43
249	68	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:52:17
250	68	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3516	2026-05-30 09:52:17
251	69	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:54:22
252	69	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4081	2026-05-30 09:54:22
253	70	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:55:17
254	70	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2804	2026-05-30 09:55:17
255	71	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:56:23
256	71	2	1	\N	\N	\N	\N	\N	正在为您查询库存…	\N	\N	\N	inventory	\N	9082	2026-05-30 09:56:23
257	72	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 09:59:26
258	72	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3120	2026-05-30 09:59:26
259	73	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:21:36
260	73	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3697	2026-05-30 10:21:36
261	74	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:29:46
262	74	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	6168	2026-05-30 10:29:46
263	75	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:37:15
264	75	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2481	2026-05-30 10:37:15
265	76	1	1	查今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:39:22
266	76	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2526	2026-05-30 10:39:22
267	77	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:50:49
268	77	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4178	2026-05-30 10:50:49
269	78	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:54:35
270	78	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3497	2026-05-30 10:54:35
271	79	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 10:56:41
272	79	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3904	2026-05-30 10:56:41
273	79	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 10:56:53
274	79	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2798	2026-05-30 10:56:53
275	79	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 10:57:04
276	79	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3026	2026-05-30 10:57:04
277	80	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 11:27:51
278	80	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2650	2026-05-30 11:27:51
279	80	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 11:28:00
280	80	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，专注于帮您管理库存、销售和订单。	\N	\N	\N	inventory	\N	2544	2026-05-30 11:28:00
281	80	1	1	写一个工作总结	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 11:28:09
282	80	2	1	\N	\N	\N	\N	\N	抱歉，我无法处理您的工作总结请求。	\N	\N	\N	inventory	\N	1905	2026-05-30 11:28:09
283	80	1	1	你叫什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 11:28:18
284	80	2	1	\N	\N	\N	\N	\N	我是舌尖香港AI助手	\N	\N	\N	inventory	\N	3094	2026-05-30 11:28:19
285	80	1	1	香港到深圳怎么走	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 11:28:31
286	80	2	1	\N	\N	\N	\N	\N	抱歉，我是生鲜门店助手，无法回答交通问题。请问您需要什么帮助？	\N	\N	\N	inventory	\N	4357	2026-05-30 11:28:31
287	81	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 12:09:48
288	81	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	12979	2026-05-30 12:09:48
289	81	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 12:16:53
290	81	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2547	2026-05-30 12:16:53
291	82	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 12:22:49
292	82	2	1	\N	\N	\N	\N	\N	我是您的生鲜门店AI助手，随时为您服务。	\N	\N	\N	inventory	\N	2336	2026-05-30 12:22:49
293	83	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 12:35:09
294	83	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2522	2026-05-30 12:35:09
295	83	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 12:35:16
296	83	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3003	2026-05-30 12:35:16
297	84	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 12:53:40
298	84	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	9168	2026-05-30 12:53:40
299	84	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 12:56:07
300	84	2	1	\N	\N	\N	\N	\N	正在为您查询今日销售情况…	\N	\N	\N	inventory	\N	9187	2026-05-30 12:56:07
301	84	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 12:59:27
302	84	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	9007	2026-05-30 12:59:27
303	84	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 12:59:41
304	84	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	9122	2026-05-30 12:59:41
305	83	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 13:03:03
306	83	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，可以帮您记录进货、销售、损耗、库存盘点，查询库存、销售、天气、建议等。	\N	\N	\N	inventory	\N	3475	2026-05-30 13:03:03
307	84	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:03:40
308	84	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2277	2026-05-30 13:03:40
309	83	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 13:06:34
310	83	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	4731	2026-05-30 13:06:34
311	85	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:06:54
312	85	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2547	2026-05-30 13:06:54
313	86	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:08:20
314	86	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3684	2026-05-30 13:08:20
315	86	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:09:06
316	86	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	13402	2026-05-30 13:09:06
317	87	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:11:54
318	87	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	5067	2026-05-30 13:11:54
319	87	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 13:15:18
320	87	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2342	2026-05-30 13:15:18
321	88	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 14:32:33
322	88	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	10946	2026-05-30 14:32:33
323	88	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 14:33:53
324	88	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8182	2026-05-30 14:33:53
325	89	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 15:04:02
326	89	2	1	\N	\N	\N	\N	\N	我是舌尖香港AI助手，随时为您处理生鲜门店事务。	\N	\N	\N	inventory	\N	3777	2026-05-30 15:04:02
327	90	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 15:29:27
328	90	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3098	2026-05-30 15:29:27
329	90	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 15:30:11
330	90	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2721	2026-05-30 15:30:11
331	91	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 16:04:05
332	91	2	1	\N	\N	\N	\N	\N	正在为您查询...	\N	\N	\N	inventory	\N	2435	2026-05-30 16:04:05
333	92	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 16:05:10
334	92	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	4041	2026-05-30 16:05:10
335	92	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 16:05:23
336	92	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	7382	2026-05-30 16:05:23
337	92	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 16:05:54
338	92	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，可以帮您处理进货、销售、库存管理、损耗记录、查询报表等事务。	\N	\N	\N	inventory	\N	3516	2026-05-30 16:05:54
339	92	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 16:06:04
340	92	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4841	2026-05-30 16:06:04
341	92	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 16:06:16
342	92	2	1	\N	\N	\N	\N	\N	我可以帮您处理进货录入、销售记录、报损耗、库存盘点、查询库存销售数据、查看天气、处理退款申请等。	\N	\N	\N	inventory	\N	3232	2026-05-30 16:06:16
343	92	1	1	进货2斤苹果	\N	\N	\N	\N	\N	purchase_receipt	[{"qty": 2, "unit": "斤", "action": "in", "product_name": "苹果"}]	\N	\N	\N	\N	2026-05-30 16:06:30
344	92	2	1	\N	\N	\N	\N	\N	已记录进货2斤苹果。	\N	\N	\N	inventory	\N	2745	2026-05-30 16:06:30
345	92	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 16:06:43
346	92	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	9699	2026-05-30 16:06:43
347	92	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	purchase_orders_query	[]	\N	\N	\N	\N	2026-05-30 16:06:50
348	92	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2914	2026-05-30 16:06:50
349	93	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 16:15:09
350	93	2	1	\N	\N	\N	\N	\N	正在为您查询今日库存…	\N	\N	\N	inventory	\N	5317	2026-05-30 16:15:09
351	93	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 16:15:20
352	93	2	1	\N	\N	\N	\N	\N	我可以帮您处理生鲜门店的进货、销售、库存、损耗等记录，查询库存、销售、天气、建议等信息。请告诉我您需要什么帮助。	\N	\N	\N	inventory	\N	3649	2026-05-30 16:15:20
353	94	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 18:47:05
354	94	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2777	2026-05-30 18:47:05
355	94	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 18:47:27
356	94	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3067	2026-05-30 18:47:27
357	94	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 18:47:36
358	94	2	1	\N	\N	\N	\N	\N	我可以帮您管理生鲜门店的进货、销售、库存、损耗等操作，以及查询天气、建议等。请直接告诉我您的需求。	\N	\N	\N	inventory	\N	5192	2026-05-30 18:47:36
359	95	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 19:21:39
360	95	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2751	2026-05-30 19:21:39
361	95	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 19:26:38
362	95	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	12093	2026-05-30 19:26:38
363	95	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 19:27:48
364	95	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	4801	2026-05-30 19:27:48
365	96	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 19:57:18
366	96	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	5574	2026-05-30 19:57:18
367	97	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 21:17:22
368	97	2	1	\N	\N	\N	\N	\N	正在为您查询库存…	\N	\N	\N	inventory	\N	2375	2026-05-30 21:17:22
369	97	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 21:17:45
370	97	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3207	2026-05-30 21:17:45
371	97	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 21:18:53
372	97	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，可以帮您记录进货、销售、损耗、盘点，查询库存、销售、天气、建议等。请告诉我具体需求。	\N	\N	\N	inventory	\N	3272	2026-05-30 21:18:53
373	98	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 21:46:44
374	98	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2672	2026-05-30 21:46:44
375	98	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 21:47:03
376	98	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3902	2026-05-30 21:47:03
377	98	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 21:47:35
378	98	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	15404	2026-05-30 21:47:35
379	99	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 21:50:27
380	99	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	6887	2026-05-30 21:50:27
381	99	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 21:51:43
382	99	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3019	2026-05-30 21:51:43
383	99	1	1	给我一些进货和促销建议	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-05-30 21:53:43
384	99	2	1	\N	\N	\N	\N	\N	正在为您查询进货和促销建议…	\N	\N	\N	inventory	\N	2376	2026-05-30 21:53:43
385	99	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-30 21:54:02
386	99	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	8186	2026-05-30 21:54:02
387	99	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-30 21:54:34
388	99	2	1	\N	\N	\N	\N	\N	我是你的生鲜门店AI助手，可以帮你记录进货、销售、损耗、盘点、查库存、查天气、查看退款申请和经营建议等。	\N	\N	\N	inventory	\N	3195	2026-05-30 21:54:34
389	99	1	1	刚刚有2斤草莓是坏的	\N	\N	\N	\N	\N	waste_report	[{"qty": 2, "unit": "斤", "action": "out", "reason": "变质", "product_name": "草莓"}]	\N	\N	\N	\N	2026-05-30 21:55:05
390	99	2	1	\N	\N	\N	\N	\N	已记录草莓损耗2斤（变质）。	\N	\N	\N	inventory	\N	4205	2026-05-30 21:55:05
391	99	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-30 21:55:14
392	99	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4949	2026-05-30 21:55:14
393	99	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-30 21:55:21
394	99	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2557	2026-05-30 21:55:21
395	99	1	1	橘子卖不动了	\N	\N	\N	\N	\N	suggestions_query	[{"unit": "斤", "product_name": "橘子"}]	\N	\N	\N	\N	2026-05-30 21:57:36
396	99	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	6857	2026-05-30 21:57:36
397	100	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-31 05:06:30
398	100	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4210	2026-05-31 05:06:30
399	100	1	1	今天卖了多少	\N	\N	\N	\N	\N	sales_today_query	[]	\N	\N	\N	\N	2026-05-31 05:10:47
400	100	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2678	2026-05-31 05:10:47
401	101	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 06:20:06
402	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	8123	2026-05-31 06:20:06
403	101	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 06:27:08
404	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3272	2026-05-31 06:27:08
405	101	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 06:33:23
406	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2816	2026-05-31 06:33:23
407	101	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 06:35:48
408	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2927	2026-05-31 06:35:48
409	101	1	1	给我一些进货和促销建议	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-05-31 06:39:16
410	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2352	2026-05-31 06:39:16
411	101	1	1	查一下今日库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 06:40:06
412	101	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	9375	2026-05-31 06:40:06
413	102	1	1	销售的白菜有多少	\N	\N	\N	\N	\N	product_query	[{"product_name": "白菜"}]	\N	\N	\N	\N	2026-05-31 08:00:37
414	102	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	5394	2026-05-31 08:00:37
415	103	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 08:00:53
416	103	2	1	\N	\N	\N	\N	\N	你好！有什么可以帮您？	\N	\N	\N	inventory	\N	4479	2026-05-31 08:00:53
417	104	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 08:50:24
418	104	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	494	2026-05-31 08:50:24
419	104	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 08:50:31
420	104	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	490	2026-05-31 08:50:31
421	104	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 08:53:06
422	104	2	1	\N	\N	\N	\N	\N	你好！我是舌尖香港AI助手，有什么可以帮您？	\N	\N	\N	inventory	\N	3171	2026-05-31 08:53:06
423	105	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-05-31 09:38:05
424	105	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	3888	2026-05-31 09:38:05
425	105	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 09:38:17
426	105	2	1	\N	\N	\N	\N	\N	我是生鲜门店AI助手，可以帮您录入进货、报售、报损耗、盘点库存，查询库存、销售、进货单、操作日志、天气、退款申请和进货建议等。	\N	\N	\N	inventory	\N	3431	2026-05-31 09:38:17
427	106	1	1	库存	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-05-31 09:43:07
428	106	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2670	2026-05-31 09:43:07
429	106	1	1	损耗	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 09:43:29
430	106	2	1	\N	\N	\N	\N	\N	请提供具体损耗信息，如'豆腐坏了10斤'	\N	\N	\N	inventory	\N	7459	2026-05-31 09:43:29
431	107	1	1	我现在能干点什么？	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-05-31 19:23:19
432	107	2	1	\N	\N	\N	\N	\N	您可以向我报进货、售出、损耗、剩余、盘点，或查询库存、销售、日志、天气、建议等。	\N	\N	\N	inventory	\N	4097	2026-05-31 19:23:19
433	108	1	1	保单查询	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-01 18:07:49
434	108	2	1	\N	\N	\N	\N	\N	抱歉，我只能处理生鲜门店相关事务，无法查询保单。	\N	\N	\N	inventory	\N	2624	2026-06-01 18:07:49
435	109	1	1	今天有没有录单	\N	\N	\N	\N	\N	daily_logs_query	[]	\N	\N	\N	\N	2026-06-01 18:13:46
436	109	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	3616	2026-06-01 18:13:46
437	109	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-01 18:14:01
438	109	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2707	2026-06-01 18:14:01
439	110	1	1	录销售	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-02 08:24:03
440	110	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	598	2026-06-02 08:24:03
441	111	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-02 16:23:33
442	111	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	496	2026-06-02 16:23:33
443	111	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-02 16:23:36
444	111	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	490	2026-06-02 16:23:36
445	112	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 00:58:29
446	112	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	553	2026-06-03 00:58:29
447	113	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 02:08:05
448	113	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	545	2026-06-03 02:08:05
449	114	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 09:03:59
450	114	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	495	2026-06-03 09:03:59
451	115	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 17:32:03
452	115	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	492	2026-06-03 17:32:03
453	115	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 17:46:00
454	115	2	1	\N	\N	\N	\N	\N	您好！我是舌尖香港门店AI助手，可以帮您记录进货、销售、盘点、损耗，也能查询库存、销售、天气和会员信息。请问需要什么帮助？	\N	\N	\N	inventory	\N	2962	2026-06-03 17:46:00
455	115	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-03 17:47:57
456	115	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	1776	2026-06-03 17:47:57
457	115	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-03 17:48:07
458	115	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	1478	2026-06-03 17:48:07
459	115	1	1	你是说	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-03 17:48:20
460	115	2	1	\N	\N	\N	\N	\N	无法解析您的输入，请描述商品名称和数量，例如：收到50斤胡萝卜。	\N	\N	\N	inventory	\N	4603	2026-06-03 17:48:20
461	116	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-03 20:29:58
462	116	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2248	2026-06-03 20:29:58
463	116	1	1	牛油果出货一件	\N	\N	\N	\N	\N	sale_report	[{"product_name":"\\u725b\\u6cb9\\u679c","qty":1,"unit":"\\u7bb1","action":"sell","reason":""}]	\N	\N	\N	\N	2026-06-03 20:30:47
464	116	2	1	\N	\N	\N	\N	\N	已记录牛油果售出1箱。	\N	\N	\N	inventory	\N	32566	2026-06-03 20:30:47
465	117	1	1	明天天气怎么样	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-07 10:55:57
466	117	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	687	2026-06-07 10:55:57
467	117	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-07 10:55:59
468	117	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	657	2026-06-07 10:55:59
469	118	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-07 11:01:36
470	118	2	1	\N	\N	\N	\N	\N	您好！我是舌尖香港的AI助手，可以帮您记录进货、销售、盘点、损耗，查询库存和营业情况，还能管理会员客户。请问有什么可以帮您？	\N	\N	\N	inventory	\N	4888	2026-06-07 11:01:36
471	119	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-09 08:26:21
472	119	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	574	2026-06-09 08:26:21
473	119	1	1	查一下最近的进货单	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-09 08:26:33
474	119	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	589	2026-06-09 08:26:33
475	119	1	1	查一下客户王明	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-09 08:28:44
476	119	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	557	2026-06-09 08:28:44
477	120	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:13:17
478	120	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	596	2026-06-11 22:13:17
479	121	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:17:22
480	121	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	253	2026-06-11 22:17:22
481	121	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:17:30
482	121	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	539	2026-06-11 22:17:30
483	121	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:18:43
484	121	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	932	2026-06-11 22:18:43
485	121	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:18:51
486	121	2	1	\N	\N	\N	\N	\N	您好！我是舌尖香港门店AI助手，可以帮您记录进货、销售、盘点、损耗，也能查库存、销售、天气和管理会员。请问有什么需要？	\N	\N	\N	inventory	\N	3874	2026-06-11 22:18:51
487	122	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:19:42
488	122	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	421	2026-06-11 22:19:42
489	122	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:19:50
490	122	2	1	\N	\N	\N	\N	\N	我是舌尖香港的门店AI助手，随时在这里为您服务。您可以让我帮您记录进货、销售、盘点、损耗，或查询库存、销售、天气、客户等情况。请问需要什么帮助？	\N	\N	\N	inventory	\N	4042	2026-06-11 22:19:50
491	122	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:20:46
492	122	2	1	\N	\N	\N	\N	\N	我是舌尖香港AI助手，为您管理生鲜门店。	\N	\N	\N	inventory	\N	2217	2026-06-11 22:20:46
493	122	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-11 22:20:53
494	122	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2875	2026-06-11 22:20:53
495	122	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:21:00
496	122	2	1	\N	\N	\N	\N	\N	我是舌尖香港生鲜门店AI助手，可以帮您记录进货、售出、剩余、盘点、损耗，查询库存、销售、订单、天气、退款、建议，以及管理顾客信息和跟进记录。	\N	\N	\N	inventory	\N	2885	2026-06-11 22:21:00
497	122	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-11 22:24:11
498	122	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2391	2026-06-11 22:24:11
499	122	1	1	你在哪里	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 22:42:12
500	122	2	1	\N	\N	\N	\N	\N	我在您的生鲜门店AI助手系统里，随时待命。	\N	\N	\N	inventory	\N	2697	2026-06-11 22:42:12
501	122	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-11 22:42:20
502	122	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2958	2026-06-11 22:42:20
503	123	1	1	当前产能进度如何	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 23:36:41
504	123	2	1	\N	\N	\N	\N	\N	抱歉，我无法理解您的问题，请说明具体需求（如查库存、报销售等）。	\N	\N	\N	inventory	\N	2861	2026-06-11 23:36:41
505	123	1	1	查一下生产订单	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-11 23:36:49
506	123	2	1	\N	\N	\N	\N	\N	抱歉，我目前无法查询生产订单。您可以尝试查询进货记录、库存或销售情况，需要我帮您查这些吗？	\N	\N	\N	inventory	\N	5079	2026-06-11 23:36:49
507	123	1	1	物料还剩多少	\N	\N	\N	\N	\N	inventory_query	[]	\N	\N	\N	\N	2026-06-11 23:36:54
508	123	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2443	2026-06-11 23:36:54
509	124	1	1	帮客户办一张会员卡	\N	\N	\N	\N	\N	customer_add	[]	\N	\N	\N	\N	2026-06-11 23:37:54
510	124	2	1	\N	\N	\N	\N	\N	请提供会员的姓名和手机号。	\N	\N	\N	inventory	\N	3419	2026-06-11 23:37:54
511	125	1	1	帮我登记今天的上新款	\N	\N	\N	\N	\N	purchase_receipt	[]	\N	\N	\N	\N	2026-06-12 00:19:48
512	125	2	1	\N	\N	\N	\N	\N	请告诉我今天上新的商品名称和数量。	\N	\N	\N	inventory	\N	6411	2026-06-12 00:19:48
513	126	1	1	查一下今天的订单	\N	\N	\N	\N	\N	customer_orders_query	[]	\N	\N	\N	\N	2026-06-12 00:20:16
514	126	2	1	\N	\N	\N	\N	\N	正在为您查询今天的客户订单…	\N	\N	\N	inventory	\N	9899	2026-06-12 00:20:16
515	127	1	1	有哪些客户需要回访	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 00:21:40
516	127	2	1	\N	\N	\N	\N	\N	正在为您查询需要回访的客户…	\N	\N	\N	inventory	\N	6522	2026-06-12 00:21:40
517	128	1	1	查一下账户情况	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 00:42:48
518	128	2	1	\N	\N	\N	\N	\N	抱歉，我目前只能处理与生鲜门店相关的业务，无法查询账户情况。	\N	\N	\N	inventory	\N	3833	2026-06-12 00:42:48
519	128	1	1	帮我对账	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 00:42:52
520	128	2	1	\N	\N	\N	\N	\N	请问您需要对哪方面的账？库存、销售还是进货？	\N	\N	\N	inventory	\N	3278	2026-06-12 00:42:52
521	128	1	1	查一下客户信息	\N	\N	\N	\N	\N	customer_query	[]	\N	\N	\N	\N	2026-06-12 00:42:54
522	128	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	1836	2026-06-12 00:42:54
523	128	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-12 00:42:59
524	128	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	2710	2026-06-12 00:42:59
525	128	1	1	有哪些风控预警	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 00:43:23
526	128	2	1	\N	\N	\N	\N	\N	您好，我目前不支持风控预警查询功能，请重新输入。	\N	\N	\N	inventory	\N	2012	2026-06-12 00:43:23
527	129	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-12 05:21:57
528	129	2	1	\N	\N	\N	\N	\N	正在为您查询明天天气…	\N	\N	\N	inventory	\N	7580	2026-06-12 05:21:57
529	130	1	1	有哪些客户需要跟进	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 05:29:32
530	130	2	1	\N	\N	\N	\N	\N	抱歉，我无法直接处理“有哪些客户需要跟进”这类问题，请尝试通过客户查询或操作日志了解跟进情况。	\N	\N	\N	inventory	\N	4234	2026-06-12 05:29:32
531	131	1	1	今天的销售概况	\N	\N	\N	\N	\N	daily_overview_query	[]	\N	\N	\N	\N	2026-06-12 11:06:22
532	131	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2923	2026-06-12 11:06:22
533	132	1	1	今日进货苹果100斤	\N	\N	\N	\N	\N	purchase_receipt	[{"product_name":"\\u82f9\\u679c","qty":100,"unit":"\\u65a4","action":"in"}]	\N	\N	\N	\N	2026-06-12 11:46:28
534	132	2	1	\N	\N	\N	\N	\N	已记录进货苹果100斤	\N	\N	\N	inventory	\N	3371	2026-06-12 11:46:28
535	132	1	1	哪些货品需要备货了	\N	\N	\N	\N	\N	suggestions_query	[]	\N	\N	\N	\N	2026-06-12 11:47:01
536	132	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	1994	2026-06-12 11:47:01
537	133	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-12 19:43:22
538	133	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	6250	2026-06-12 19:43:22
539	133	1	1	明天天气怎么样	\N	\N	\N	\N	\N	weather_query	[]	\N	\N	\N	\N	2026-06-12 19:43:30
540	133	2	1	\N	\N	\N	\N	\N	正在为您查询天气…	\N	\N	\N	inventory	\N	1811	2026-06-12 19:43:30
541	134	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 20:13:32
542	134	2	1	\N	\N	\N	\N	\N	我是舌尖香港生鲜门店AI助手，可以帮您处理进货、销售、库存、损耗、查询、客户管理等事务。请直接告诉我您的需求。	\N	\N	\N	inventory	\N	2586	2026-06-12 20:13:32
543	134	1	1	查一下今天的订单情况	\N	\N	\N	\N	\N	customer_orders_query	[]	\N	\N	\N	\N	2026-06-12 20:14:37
544	134	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	4062	2026-06-12 20:14:37
545	134	1	1	最近的经营数据报表	\N	\N	\N	\N	\N	daily_overview_query	[]	\N	\N	\N	\N	2026-06-12 20:14:58
546	134	2	1	\N	\N	\N	\N	\N	正在为您查询…	\N	\N	\N	inventory	\N	2067	2026-06-12 20:14:58
547	134	1	1	请帮我规划一套电商产品主图和详情图的设计方案，包括构图建议、文案布局、色彩搭配。请描述你的产品：	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-12 20:15:54
548	134	2	1	\N	\N	\N	\N	\N	请提供您的生鲜商品信息，我才能帮您规划主图和详情设计哦。	\N	\N	\N	inventory	\N	2269	2026-06-12 20:15:54
549	135	1	1	今天的生产概况	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 09:46:26
550	135	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	309	2026-06-13 09:46:26
551	135	1	1	物料还剩多少	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 09:46:30
552	135	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	211	2026-06-13 09:46:30
553	135	1	1	明天天气怎么样	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 09:46:33
554	135	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	187	2026-06-13 09:46:33
555	136	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 09:57:39
556	136	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	190	2026-06-13 09:57:39
557	137	1	1	今天的什么品种卖的好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 17:39:57
558	137	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	178	2026-06-13 17:39:57
559	138	1	1	最近哪些款式卖得好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-13 18:18:29
560	138	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	259	2026-06-13 18:18:29
561	139	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 03:04:19
562	139	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	223	2026-06-14 03:04:19
563	140	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 03:06:17
564	140	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	211	2026-06-14 03:06:17
565	141	1	1	需要补哪些货	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 03:41:22
566	141	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	223	2026-06-14 03:41:22
567	141	1	1	现在有哪些促销	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 03:41:32
568	141	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	202	2026-06-14 03:41:32
569	141	1	1	现在有哪些促销	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 03:41:43
570	141	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	228	2026-06-14 03:41:43
571	142	1	1	明天天气怎么样	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 08:13:33
572	142	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	218	2026-06-14 08:13:33
573	143	1	1	明天天气怎么样	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 08:37:38
574	143	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	226	2026-06-14 08:37:38
575	144	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 12:17:16
576	144	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	231	2026-06-14 12:17:16
577	145	1	1	帮我对账	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 12:17:38
578	145	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	224	2026-06-14 12:17:38
579	145	1	1	你能帮我做什么	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 12:17:42
580	145	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	223	2026-06-14 12:17:42
581	146	1	1	最近哪些项目最受欢迎	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 16:21:33
582	146	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	260	2026-06-14 16:21:33
583	147	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 16:21:58
584	147	2	1	\N	\N	\N	\N	\N	AI服务暂时不可用，请稍后重试。	\N	\N	\N	inventory	\N	239	2026-06-14 16:21:58
585	148	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-14 16:25:29
586	148	2	1	\N	\N	\N	\N	\N	你好！有什么可以帮您的？	\N	\N	\N	inventory	\N	1996	2026-06-14 16:25:29
587	149	1	1	你好	\N	\N	\N	\N	\N	other	[]	\N	\N	\N	\N	2026-06-15 03:52:32
588	149	2	1	\N	\N	\N	\N	\N	你好！我是舌尖香港AI助手，有什么可以帮您？	\N	\N	\N	inventory	\N	1737	2026-06-15 03:52:32
\.


--
-- Data for Name: ai_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_sessions (id, store_id, user_id, session_uuid, channel, status, started_at, ended_at, context, created_at, updated_at) FROM stdin;
1	1	1	04a76b3d-2952-4160-a476-cf59b3e7bd14	2	1	2026-03-22 06:59:53	\N	\N	2026-03-22 06:59:53	2026-03-22 06:59:53
2	1	8	c1669a74-93cf-47be-ab9c-6fe27f0bbb96	2	1	2026-03-31 04:22:14	\N	\N	2026-03-31 04:22:14	2026-03-31 04:22:14
3	1	8	9bfd5857-1a12-4973-a1a7-6e36e361b399	2	1	2026-03-31 04:22:18	\N	\N	2026-03-31 04:22:18	2026-03-31 04:22:18
4	1	8	d635de27-5577-4c0d-8158-6ba3915ea69b	2	1	2026-03-31 04:22:38	\N	\N	2026-03-31 04:22:38	2026-03-31 04:22:38
5	1	8	1c6d9a63-3ca4-4487-82cd-d80b1c2f5aaa	2	1	2026-03-31 04:43:14	\N	\N	2026-03-31 04:43:14	2026-03-31 04:43:14
6	1	8	cff40983-fd18-4629-852f-507c5bd4d197	2	1	2026-03-31 05:22:10	\N	\N	2026-03-31 05:22:10	2026-03-31 05:22:10
7	1	8	c6e7d292-2d7a-4ca4-8833-21d4b1d982c2	2	1	2026-03-31 05:27:34	\N	\N	2026-03-31 05:27:34	2026-03-31 05:27:34
8	1	8	77555e81-8ce8-44ec-9a02-12c91f8b279e	2	1	2026-03-31 05:43:45	\N	\N	2026-03-31 05:43:45	2026-03-31 05:43:45
9	2	9	7f5959a7-f43b-433b-a902-a65b8db16e97	2	1	2026-03-31 08:49:04	\N	\N	2026-03-31 08:49:04	2026-03-31 08:49:04
10	2	9	5260867c-c0f6-4bf3-babf-0b6406d183e4	2	1	2026-04-01 07:38:14	\N	\N	2026-04-01 07:38:14	2026-04-01 07:38:14
11	2	9	4a2d5391-6c48-44fd-82d7-390c1c14bee6	2	1	2026-04-01 08:41:59	\N	\N	2026-04-01 08:41:59	2026-04-01 08:41:59
12	2	1	e2c09c45-1d15-460f-b75e-61e3f7902c38	2	1	2026-04-26 18:30:31	\N	\N	2026-04-26 18:30:31	2026-04-26 18:30:31
13	1	12	b18fa3f4-3076-4da4-91a2-d981fe3bd1e6	2	1	2026-04-26 19:25:46	\N	\N	2026-04-26 19:25:46	2026-04-26 19:25:46
14	1	12	cc7f8ed0-0d29-4910-b2d5-1b39b15978d0	2	1	2026-04-27 20:58:35	\N	\N	2026-04-27 20:58:35	2026-04-27 20:58:35
15	1	12	ff84527c-867e-4adc-b3ab-f1ea3ab95bcd	2	1	2026-04-27 21:28:43	\N	\N	2026-04-27 21:28:43	2026-04-27 21:28:43
16	2	1	bbf3f188-f956-434d-b6d5-b18b9aa52a7e	2	1	2026-04-27 21:56:47	\N	\N	2026-04-27 21:56:47	2026-04-27 21:56:47
17	2	1	d7d0b9d7-75c9-4a10-b02a-56dacd2ac0f7	2	1	2026-04-27 21:56:53	\N	\N	2026-04-27 21:56:53	2026-04-27 21:56:53
18	1	12	5388c721-5355-49f3-b89a-5e2054d11b0d	2	1	2026-04-27 22:05:17	\N	\N	2026-04-27 22:05:17	2026-04-27 22:05:17
19	1	12	de2cd2c6-0717-4656-b1b7-d2c340d3da0f	2	1	2026-04-27 22:22:37	\N	\N	2026-04-27 22:22:37	2026-04-27 22:22:37
20	1	12	c65692e8-d0ae-403c-9fea-112ba9c2e776	2	1	2026-04-27 22:26:17	\N	\N	2026-04-27 22:26:17	2026-04-27 22:26:17
21	1	12	fbb000cb-e865-45fa-8188-103773589883	2	1	2026-04-27 22:58:45	\N	\N	2026-04-27 22:58:45	2026-04-27 22:58:45
22	1	13	3c2bddbf-783d-4205-88df-d6581b0222c6	2	1	2026-04-28 13:07:50	\N	\N	2026-04-28 13:07:50	2026-04-28 13:07:50
23	1	12	b581f2f8-9a55-45d6-ba6b-45a6aaca08fe	2	1	2026-04-29 07:50:58	\N	\N	2026-04-29 07:50:58	2026-04-29 07:50:58
24	1	12	088af4bb-1bca-4b56-9c35-10895a95f6ab	2	1	2026-04-29 08:19:38	\N	\N	2026-04-29 08:19:38	2026-04-29 08:19:38
25	1	12	5e67ba4f-85cd-4d17-a082-e5a8e492b876	2	1	2026-05-11 05:30:30	\N	\N	2026-05-11 05:30:30	2026-05-11 05:30:30
26	1	12	d343dee4-4fc6-47e8-9994-193d505308ff	3	1	2026-05-11 05:36:06	\N	\N	2026-05-11 05:36:06	2026-05-11 05:36:06
27	1	12	0707152d-b559-48aa-b6d2-801328579111	2	1	2026-05-11 05:39:40	\N	\N	2026-05-11 05:39:40	2026-05-11 05:39:40
28	1	12	bdc929c5-809f-4f38-b2e8-b421a239c18c	3	1	2026-05-11 05:41:34	\N	\N	2026-05-11 05:41:34	2026-05-11 05:41:34
29	1	12	7d05ee38-907f-4472-a48d-72e71886549d	2	1	2026-05-11 05:50:10	\N	\N	2026-05-11 05:50:10	2026-05-11 05:50:10
30	1	12	c5b022ce-139d-4297-85fe-ef9c5199d05c	2	1	2026-05-11 07:21:48	\N	\N	2026-05-11 07:21:48	2026-05-11 07:21:48
31	1	12	76aa7849-b92d-4ef1-aede-52aefa8e0c88	2	1	2026-05-11 07:24:10	\N	\N	2026-05-11 07:24:10	2026-05-11 07:24:10
32	1	12	f65906b5-5506-4d49-bee4-0af267c736f1	2	1	2026-05-11 07:53:46	\N	\N	2026-05-11 07:53:46	2026-05-11 07:53:46
33	1	12	88caa41b-d53a-4086-87f9-4512e2fd5dff	2	1	2026-05-11 19:51:03	\N	\N	2026-05-11 19:51:03	2026-05-11 19:51:03
34	1	12	f7778df5-e8cd-4902-8dcd-99ee5b25bccc	2	1	2026-05-11 19:51:17	\N	\N	2026-05-11 19:51:17	2026-05-11 19:51:17
35	1	13	00777af5-a19f-4948-a986-051df8138fc2	2	1	2026-05-11 20:00:50	\N	\N	2026-05-11 20:00:50	2026-05-11 20:00:50
36	1	12	733a8b90-779c-40fa-b795-84446015829f	2	1	2026-05-11 20:28:27	\N	\N	2026-05-11 20:28:27	2026-05-11 20:28:27
37	1	12	8b82fce1-17c9-4078-a37a-d296a185adc8	2	1	2026-05-11 20:29:00	\N	\N	2026-05-11 20:29:00	2026-05-11 20:29:00
38	1	12	777844e1-6a59-4cd8-9ff6-225783ea77c6	2	1	2026-05-11 21:02:02	\N	\N	2026-05-11 21:02:02	2026-05-11 21:02:02
39	1	12	77206b98-e005-4b85-a500-7924cbc5dc39	2	1	2026-05-11 21:04:12	\N	\N	2026-05-11 21:04:12	2026-05-11 21:04:12
40	1	12	e1d6a027-ad23-4536-83b4-ad8a7836cae2	2	1	2026-05-11 21:08:24	\N	\N	2026-05-11 21:08:24	2026-05-11 21:08:24
41	1	12	a4700340-08f2-4355-98c1-dfd85f5cc64b	2	1	2026-05-11 21:26:14	\N	\N	2026-05-11 21:26:14	2026-05-11 21:26:14
42	2	1	3b082dde-0714-4d84-96b3-904441b87484	2	1	2026-05-11 21:35:20	\N	\N	2026-05-11 21:35:20	2026-05-11 21:35:20
43	2	1	075d95c1-b614-4d67-bfe9-06b92585cc64	2	1	2026-05-11 21:38:17	\N	\N	2026-05-11 21:38:17	2026-05-11 21:38:17
44	3	8	3025fe63-d26b-4d15-94e7-68abfd71f4f3	2	1	2026-05-30 07:03:28	\N	\N	2026-05-30 07:03:28	2026-05-30 07:03:28
45	3	8	0831c0a4-949b-49c7-85c4-9a4b1ec3d217	2	1	2026-05-30 07:03:32	\N	\N	2026-05-30 07:03:32	2026-05-30 07:03:32
46	3	8	a0f9ef17-46c6-4f8a-a3f2-c34865e2a5b2	2	1	2026-05-30 07:06:39	\N	\N	2026-05-30 07:06:39	2026-05-30 07:06:39
47	3	8	b9b041aa-e267-416c-b75f-a31d7fc68bbc	2	1	2026-05-30 07:06:44	\N	\N	2026-05-30 07:06:44	2026-05-30 07:06:44
48	3	8	22a815ab-a2bf-4950-9c57-d602cc70e60e	2	1	2026-05-30 07:06:48	\N	\N	2026-05-30 07:06:48	2026-05-30 07:06:48
49	3	8	8c1c1c3f-bbed-48e8-b446-9d25828ff7bc	2	1	2026-05-30 07:06:51	\N	\N	2026-05-30 07:06:51	2026-05-30 07:06:51
50	1	12	218d76a6-b017-4ff9-981b-eb2beb3262ac	2	1	2026-05-30 07:12:14	\N	\N	2026-05-30 07:12:14	2026-05-30 07:12:14
51	1	12	e07f81dd-717d-431e-a468-03e3e3685c69	2	1	2026-05-30 07:44:44	\N	\N	2026-05-30 07:44:44	2026-05-30 07:44:44
52	1	12	ac317b4f-93c4-4f8b-9988-c0f1c88a84ba	2	1	2026-05-30 07:59:26	\N	\N	2026-05-30 07:59:26	2026-05-30 07:59:26
53	1	12	5282bb35-161a-4462-a837-d61b6a90ed62	2	1	2026-05-30 08:08:32	\N	\N	2026-05-30 08:08:32	2026-05-30 08:08:32
54	1	12	72f7549d-0047-40c4-9832-41cddeafa923	2	1	2026-05-30 08:11:58	\N	\N	2026-05-30 08:11:58	2026-05-30 08:11:58
55	1	12	f4bfe4ac-66b5-4cc3-a799-805922b73adb	2	1	2026-05-30 08:16:55	\N	\N	2026-05-30 08:16:55	2026-05-30 08:16:55
56	1	12	148027b8-58b3-4773-8433-b79cc334ae64	2	1	2026-05-30 08:28:31	\N	\N	2026-05-30 08:28:31	2026-05-30 08:28:31
57	1	12	6bc03af7-4496-485e-a65e-68325e6a0e7e	2	1	2026-05-30 08:29:12	\N	\N	2026-05-30 08:29:12	2026-05-30 08:29:12
58	1	12	fe8cf5dc-f87b-4271-a7e4-c3dfe3922282	2	1	2026-05-30 08:40:38	\N	\N	2026-05-30 08:40:38	2026-05-30 08:40:38
59	1	12	f149bd65-4a21-468e-b774-d13482d4975a	2	1	2026-05-30 08:42:45	\N	\N	2026-05-30 08:42:45	2026-05-30 08:42:45
60	1	12	e77227bf-888a-4194-b5d6-06f1504095a2	2	1	2026-05-30 08:47:33	\N	\N	2026-05-30 08:47:33	2026-05-30 08:47:33
61	1	12	4e0e9e8e-17fa-4cf9-a8f9-1e179a63bbb9	2	1	2026-05-30 08:47:50	\N	\N	2026-05-30 08:47:50	2026-05-30 08:47:50
62	1	12	90a6e919-0333-405e-bfdd-c70a801fbe8d	2	1	2026-05-30 08:58:38	\N	\N	2026-05-30 08:58:38	2026-05-30 08:58:38
63	1	12	e033aa07-457f-4336-a21f-bfdfc7c33c3e	2	1	2026-05-30 08:59:34	\N	\N	2026-05-30 08:59:34	2026-05-30 08:59:34
64	1	12	e9f801a6-9f8b-4eb8-8cca-09eb20ea0f64	2	1	2026-05-30 09:00:17	\N	\N	2026-05-30 09:00:17	2026-05-30 09:00:17
65	1	12	85c5f025-75c6-41c7-8e81-948038c91915	2	1	2026-05-30 09:09:54	\N	\N	2026-05-30 09:09:54	2026-05-30 09:09:54
66	1	12	8ba6bb12-4921-4f27-a49f-020f907f7ac8	2	1	2026-05-30 09:27:14	\N	\N	2026-05-30 09:27:14	2026-05-30 09:27:14
67	1	12	47c0c5ad-6e6e-45ef-8d09-79a3d8972387	2	1	2026-05-30 09:42:23	\N	\N	2026-05-30 09:42:23	2026-05-30 09:42:23
68	1	12	d7172ca8-a901-4bcd-b543-b1f935066551	2	1	2026-05-30 09:52:13	\N	\N	2026-05-30 09:52:13	2026-05-30 09:52:13
69	1	12	e34b17c5-618a-4341-81f6-f62beb0cd52c	2	1	2026-05-30 09:54:17	\N	\N	2026-05-30 09:54:17	2026-05-30 09:54:17
70	1	12	5fc207ed-c1c1-4985-87f1-78ac66fb53bc	2	1	2026-05-30 09:55:14	\N	\N	2026-05-30 09:55:14	2026-05-30 09:55:14
71	1	12	e8d07018-60d3-433b-bbc3-8a8d92bd5727	2	1	2026-05-30 09:56:14	\N	\N	2026-05-30 09:56:14	2026-05-30 09:56:14
72	1	12	35a41398-7d16-4a75-a838-29d83db37bcd	2	1	2026-05-30 09:59:23	\N	\N	2026-05-30 09:59:23	2026-05-30 09:59:23
73	1	12	3928c09e-70fd-4ce7-8df6-17d7c08c75b1	2	1	2026-05-30 10:21:32	\N	\N	2026-05-30 10:21:32	2026-05-30 10:21:32
74	1	12	ef52c39c-7f8a-4e07-9333-82b6605496f1	2	1	2026-05-30 10:29:40	\N	\N	2026-05-30 10:29:40	2026-05-30 10:29:40
75	1	12	5343cf29-478e-4132-b339-4a16e4d7cd62	2	1	2026-05-30 10:37:13	\N	\N	2026-05-30 10:37:13	2026-05-30 10:37:13
76	3	8	28c8cade-9452-4c95-b287-e9bfcc925030	2	1	2026-05-30 10:39:19	\N	\N	2026-05-30 10:39:19	2026-05-30 10:39:19
77	1	12	40aab849-7b49-44b2-9290-920401c8d3f5	2	1	2026-05-30 10:50:45	\N	\N	2026-05-30 10:50:45	2026-05-30 10:50:45
78	1	12	5e89021a-ff22-48e0-a66c-78a469b762d1	2	1	2026-05-30 10:54:31	\N	\N	2026-05-30 10:54:31	2026-05-30 10:54:31
79	1	12	f0bea20a-0819-4984-aeb8-a98e3e109355	2	1	2026-05-30 10:56:37	\N	\N	2026-05-30 10:56:37	2026-05-30 10:56:37
80	1	12	e4cf4da7-3f35-405b-9680-345b9563609c	2	1	2026-05-30 11:27:48	\N	\N	2026-05-30 11:27:48	2026-05-30 11:27:48
81	1	12	edf09551-820c-4a57-b53f-822f1f752333	2	1	2026-05-30 12:09:35	\N	\N	2026-05-30 12:09:35	2026-05-30 12:09:35
82	1	12	ddd2ecf1-8dff-40e7-8804-79c518fa72ed	2	1	2026-05-30 12:22:46	\N	\N	2026-05-30 12:22:46	2026-05-30 12:22:46
83	1	12	1aaa4ae0-e60d-4992-b4ba-301e07da2337	2	1	2026-05-30 12:35:06	\N	\N	2026-05-30 12:35:06	2026-05-30 12:35:06
84	1	12	172607c9-88c9-4c3c-88b7-e4d067ae583d	2	1	2026-05-30 12:53:31	\N	\N	2026-05-30 12:53:31	2026-05-30 12:53:31
85	1	12	619ca090-f2bc-4e59-99ac-9b160b3d7555	2	1	2026-05-30 13:06:52	\N	\N	2026-05-30 13:06:52	2026-05-30 13:06:52
86	1	12	1aa54b70-f388-4e03-980e-c6f970d7251c	2	1	2026-05-30 13:08:16	\N	\N	2026-05-30 13:08:16	2026-05-30 13:08:16
87	1	12	fe8c4675-2042-4376-a7f0-0b4f4ef38a1f	2	1	2026-05-30 13:11:49	\N	\N	2026-05-30 13:11:49	2026-05-30 13:11:49
88	1	12	e12cd278-59b8-41e7-b71b-df393cf2b870	2	1	2026-05-30 14:32:22	\N	\N	2026-05-30 14:32:22	2026-05-30 14:32:22
89	3	8	ebcbdee9-6076-40b1-beea-fde8e6a13655	2	1	2026-05-30 15:03:59	\N	\N	2026-05-30 15:03:59	2026-05-30 15:03:59
90	1	12	3a617cbe-6989-43e0-9bd9-3efe207c1e2f	2	1	2026-05-30 15:29:24	\N	\N	2026-05-30 15:29:24	2026-05-30 15:29:24
91	1	12	5647512d-31c7-4863-9232-597464af843d	2	1	2026-05-30 16:04:02	\N	\N	2026-05-30 16:04:02	2026-05-30 16:04:02
92	1	12	54f6f089-f523-40f4-ab97-763903dafcee	2	1	2026-05-30 16:05:06	\N	\N	2026-05-30 16:05:06	2026-05-30 16:05:06
93	1	12	5765e867-ff96-4970-973a-e7aa95804db1	2	1	2026-05-30 16:15:04	\N	\N	2026-05-30 16:15:04	2026-05-30 16:15:04
94	1	12	f135e577-9c81-43e1-9bbd-abe54e4ccc0f	2	1	2026-05-30 18:47:02	\N	\N	2026-05-30 18:47:02	2026-05-30 18:47:02
95	1	12	acb00167-ede9-4d10-9548-82ac30e0b958	2	1	2026-05-30 19:21:36	\N	\N	2026-05-30 19:21:36	2026-05-30 19:21:36
96	1	12	c6580844-f745-4359-96a3-a92c7e405a8c	2	1	2026-05-30 19:57:13	\N	\N	2026-05-30 19:57:13	2026-05-30 19:57:13
97	1	12	0c70c181-817b-4625-aa9d-adf62a18420d	2	1	2026-05-30 21:17:19	\N	\N	2026-05-30 21:17:19	2026-05-30 21:17:19
98	1	12	f0f2aab7-b91a-4348-bd0c-6b3d7d69f02e	2	1	2026-05-30 21:46:42	\N	\N	2026-05-30 21:46:42	2026-05-30 21:46:42
99	1	12	82544bed-55d3-41cd-bff0-d0433b5ebd4b	2	1	2026-05-30 21:50:20	\N	\N	2026-05-30 21:50:20	2026-05-30 21:50:20
100	1	12	7dc15031-7b96-47a5-a579-c2bd3bc5c418	2	1	2026-05-31 05:06:26	\N	\N	2026-05-31 05:06:26	2026-05-31 05:06:26
101	1	12	a818fbbb-e2ee-4c4d-82b7-1d0474627c7c	2	1	2026-05-31 06:19:57	\N	\N	2026-05-31 06:19:57	2026-05-31 06:19:57
102	1	12	19b8a839-7101-41f2-98f3-7f125e92e89f	2	1	2026-05-31 08:00:31	\N	\N	2026-05-31 08:00:31	2026-05-31 08:00:31
103	1	12	4f1720dd-f1e0-4581-879b-7ebcd74eceb3	2	1	2026-05-31 08:00:49	\N	\N	2026-05-31 08:00:49	2026-05-31 08:00:49
104	1	12	41e080f4-b113-4524-9888-a75f39cbd72a	2	1	2026-05-31 08:50:24	\N	\N	2026-05-31 08:50:24	2026-05-31 08:50:24
105	1	12	ae900405-f86b-40a8-8c21-88061b806d58	2	1	2026-05-31 09:38:01	\N	\N	2026-05-31 09:38:01	2026-05-31 09:38:01
106	1	12	ad6e4889-b39c-4977-a5dd-dfcc27bf601e	2	1	2026-05-31 09:43:05	\N	\N	2026-05-31 09:43:05	2026-05-31 09:43:05
107	1	12	1ddba315-8451-45e1-81a4-5a15ffa8d68b	2	1	2026-05-31 19:23:15	\N	\N	2026-05-31 19:23:15	2026-05-31 19:23:15
108	1	12	df21236b-ba1b-40e8-9452-3c28aac66b2e	2	1	2026-06-01 18:07:46	\N	\N	2026-06-01 18:07:46	2026-06-01 18:07:46
109	1	12	14b84ad4-0883-472b-97a9-6dcdb0a40873	2	1	2026-06-01 18:13:42	\N	\N	2026-06-01 18:13:42	2026-06-01 18:13:42
110	1	12	9059cc12-4306-4db5-b511-16bba8d99694	2	1	2026-06-02 08:24:03	\N	\N	2026-06-02 08:24:03	2026-06-02 08:24:03
111	1	12	ff841de6-f7f3-45c9-9fd7-aceb22d2fa47	2	1	2026-06-02 16:23:33	\N	\N	2026-06-02 16:23:33	2026-06-02 16:23:33
112	1	12	2c74a18c-6635-42fa-bf63-01fbd05c4490	2	1	2026-06-03 00:58:28	\N	\N	2026-06-03 00:58:28	2026-06-03 00:58:28
113	1	12	dde2a12b-4660-4b6c-aee6-229b7aabae45	2	1	2026-06-03 02:08:04	\N	\N	2026-06-03 02:08:04	2026-06-03 02:08:04
114	1	12	fa37cd2b-94d6-4f7b-9f35-3bcd8ea82ed6	2	1	2026-06-03 09:03:59	\N	\N	2026-06-03 09:03:59	2026-06-03 09:03:59
115	1	12	5e34403b-f0dd-434f-98c7-107913805b8d	2	1	2026-06-03 17:32:02	\N	\N	2026-06-03 17:32:02	2026-06-03 17:32:02
116	1	12	5a910170-c2c2-4137-acc6-1b47d570f6da	2	1	2026-06-03 20:29:56	\N	\N	2026-06-03 20:29:56	2026-06-03 20:29:56
117	1	12	7ce0e960-ee3a-45f5-9203-a3c7c7f72ec6	2	1	2026-06-07 10:55:56	\N	\N	2026-06-07 10:55:56	2026-06-07 10:55:56
118	1	12	0b3c0e2b-7866-4103-872c-2898cf4e693a	2	1	2026-06-07 11:01:31	\N	\N	2026-06-07 11:01:31	2026-06-07 11:01:31
119	1	12	bb74721e-1a1c-4bf0-9fae-ed668e6f10e3	2	1	2026-06-09 08:26:20	\N	\N	2026-06-09 08:26:20	2026-06-09 08:26:20
120	1	12	94838f48-7b1c-4f4d-912f-4389d5b0a8b0	2	1	2026-06-11 22:13:17	\N	\N	2026-06-11 22:13:17	2026-06-11 22:13:17
121	1	12	2c38f4c9-a82f-4834-af15-19898e394eb2	2	1	2026-06-11 22:17:22	\N	\N	2026-06-11 22:17:22	2026-06-11 22:17:22
122	1	12	20048e25-9aa6-44a8-8a03-c1ab2989378b	2	1	2026-06-11 22:19:41	\N	\N	2026-06-11 22:19:41	2026-06-11 22:19:41
123	1	12	ff4c893c-5a51-47ef-b35d-2b4ac640dfc7	2	1	2026-06-11 23:36:38	\N	\N	2026-06-11 23:36:38	2026-06-11 23:36:38
124	1	12	f03113b4-658d-44e9-8301-f7492b36297d	2	1	2026-06-11 23:37:51	\N	\N	2026-06-11 23:37:51	2026-06-11 23:37:51
125	1	12	63e7832c-6876-4235-ae5b-0883e642c68b	2	1	2026-06-12 00:19:42	\N	\N	2026-06-12 00:19:42	2026-06-12 00:19:42
126	1	12	b9e4be14-dc3e-4275-b3ae-bcd5d636dd27	2	1	2026-06-12 00:20:06	\N	\N	2026-06-12 00:20:06	2026-06-12 00:20:06
127	1	12	595a97a0-ecbf-4ac5-a427-5fecb6bd294f	2	1	2026-06-12 00:21:33	\N	\N	2026-06-12 00:21:33	2026-06-12 00:21:33
128	1	12	7de76b23-ec9f-4428-87ec-205ae74897d7	2	1	2026-06-12 00:42:44	\N	\N	2026-06-12 00:42:44	2026-06-12 00:42:44
129	1	12	79619461-28d6-4e1a-ace8-a3fbcd58db22	2	1	2026-06-12 05:21:49	\N	\N	2026-06-12 05:21:49	2026-06-12 05:21:49
130	1	12	96327cb2-fe48-4117-b93f-832a99907378	2	1	2026-06-12 05:29:27	\N	\N	2026-06-12 05:29:27	2026-06-12 05:29:27
131	1	12	f7e4d0b7-6d21-4da5-981d-7e24cec09a56	2	1	2026-06-12 11:06:20	\N	\N	2026-06-12 11:06:20	2026-06-12 11:06:20
132	1	12	729ad5c5-a67d-4b20-b5a3-a8c3e91d8824	2	1	2026-06-12 11:46:25	\N	\N	2026-06-12 11:46:25	2026-06-12 11:46:25
133	1	12	d159132a-ed14-4443-9b5b-6cd45df4905e	2	1	2026-06-12 19:43:16	\N	\N	2026-06-12 19:43:16	2026-06-12 19:43:16
134	1	12	a21e52f6-c502-4e51-ae72-fc953a28e6db	2	1	2026-06-12 20:13:29	\N	\N	2026-06-12 20:13:29	2026-06-12 20:13:29
135	1	12	d8bf01b6-d7d8-44be-8db3-335cf4386cce	2	1	2026-06-13 09:46:26	\N	\N	2026-06-13 09:46:26	2026-06-13 09:46:26
136	1	12	8d9eb7e5-638a-4d68-bbd0-e626e8de1144	2	1	2026-06-13 09:57:39	\N	\N	2026-06-13 09:57:39	2026-06-13 09:57:39
137	1	12	9ff69233-e708-412d-8758-424b0826a9b0	2	1	2026-06-13 17:39:57	\N	\N	2026-06-13 17:39:57	2026-06-13 17:39:57
138	1	12	18934c7b-7f38-463a-b2e2-9d07545cf3d5	2	1	2026-06-13 18:18:28	\N	\N	2026-06-13 18:18:28	2026-06-13 18:18:28
139	1	12	69cb526f-8cd1-48c7-bb6d-9fb256be460c	2	1	2026-06-14 03:04:19	\N	\N	2026-06-14 03:04:19	2026-06-14 03:04:19
140	1	12	bb7e2704-a8d5-4ba6-8fc0-9f825295055e	2	1	2026-06-14 03:06:17	\N	\N	2026-06-14 03:06:17	2026-06-14 03:06:17
141	1	12	7a006560-bcff-499a-aa6b-58d142e8f79b	2	1	2026-06-14 03:41:22	\N	\N	2026-06-14 03:41:22	2026-06-14 03:41:22
142	1	12	00be65cb-9d02-4f1e-a661-ae54256a760f	2	1	2026-06-14 08:13:33	\N	\N	2026-06-14 08:13:33	2026-06-14 08:13:33
143	1	12	f9f604bd-fd12-4393-8137-b12a6900a1d8	2	1	2026-06-14 08:37:38	\N	\N	2026-06-14 08:37:38	2026-06-14 08:37:38
144	1	12	3674b897-2407-46a0-ac43-90094c3203e8	2	1	2026-06-14 12:17:16	\N	\N	2026-06-14 12:17:16	2026-06-14 12:17:16
145	1	12	4677bcf2-0ed2-49cd-b6da-0baa1522dcab	2	1	2026-06-14 12:17:37	\N	\N	2026-06-14 12:17:37	2026-06-14 12:17:37
146	1	12	66c51859-aee0-4c7e-aa56-1d6f11736e5d	2	1	2026-06-14 16:21:32	\N	\N	2026-06-14 16:21:32	2026-06-14 16:21:32
147	1	12	2933ce1f-e9fd-4625-b01f-f50e43386612	2	1	2026-06-14 16:21:58	\N	\N	2026-06-14 16:21:58	2026-06-14 16:21:58
148	1	12	4cbb1847-d570-464d-97e8-9ddce9f3d0dd	2	1	2026-06-14 16:25:27	\N	\N	2026-06-14 16:25:27	2026-06-14 16:25:27
149	1	12	46be7372-0020-422e-81a9-9b7921b29f6f	2	1	2026-06-15 03:52:30	\N	\N	2026-06-15 03:52:30	2026-06-15 03:52:30
\.


--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_settings (id, key, value, label, sort_order, created_at, updated_at) FROM stdin;
1	miniprogram_title	企业AI助手(定制AI流程)	小程序顶部标题	10	2026-05-30 15:56:26	2026-06-11 22:12:55
3	industry_page_subtitle	请选择你的行业	行业选择页小标题	30	2026-06-12 00:31:13	2026-06-12 00:31:13
2	industry_page_title	企业AI落地应用	行业选择页大标题	20	2026-06-12 00:25:31	2026-06-12 05:13:29
\.


--
-- Data for Name: attendance_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.attendance_records (id, employee_id, store_id, work_date, scheduled_start, scheduled_end, clock_in_at, clock_out_at, clock_in_source, work_hours, overtime_hours, status, exception_reason, approved_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache (key, value, expiration) FROM stdin;
laravel-cache-livewire-rate-limiter:505729277a212ad70c382a155125b1eb4cb53d7f:timer	i:1780308297;	1780308297
laravel-cache-livewire-rate-limiter:505729277a212ad70c382a155125b1eb4cb53d7f	i:1;	1780308297
laravel-cache-livewire-rate-limiter:da13aff17d640f69991026f5254175a398d7e07f:timer	i:1780388406;	1780388406
laravel-cache-livewire-rate-limiter:da13aff17d640f69991026f5254175a398d7e07f	i:1;	1780388406
laravel-cache-livewire-rate-limiter:622964188ce3aefb5d0f3c07e265c7357dd4aff6:timer	i:1780418087;	1780418087
laravel-cache-livewire-rate-limiter:622964188ce3aefb5d0f3c07e265c7357dd4aff6	i:1;	1780418087
laravel-cache-livewire-rate-limiter:2231f03eb8263983cb1c0efb5fac5078665ea34c:timer	i:1780475383;	1780475383
laravel-cache-livewire-rate-limiter:2231f03eb8263983cb1c0efb5fac5078665ea34c	i:1;	1780475383
laravel-cache-livewire-rate-limiter:1f0df09f905ba4b3fff2dc77b769de1385c278f8:timer	i:1780487857;	1780487857
laravel-cache-livewire-rate-limiter:1f0df09f905ba4b3fff2dc77b769de1385c278f8	i:3;	1780487857
laravel-cache-livewire-rate-limiter:b65676be64e76d0ad89159c470d19d0d180c9f82:timer	i:1780488057;	1780488057
laravel-cache-livewire-rate-limiter:b65676be64e76d0ad89159c470d19d0d180c9f82	i:1;	1780488057
laravel-cache-fe5dbbcea5ce7e2988b8c69bcfdfde8904aabc1f:timer	i:1780490778;	1780490778
laravel-cache-fe5dbbcea5ce7e2988b8c69bcfdfde8904aabc1f	i:1;	1780490778
laravel-cache-livewire-rate-limiter:aed75d2e9fad65fa92e16657500ae54c54aeffe8:timer	i:1780992117;	1780992117
laravel-cache-livewire-rate-limiter:aed75d2e9fad65fa92e16657500ae54c54aeffe8	i:1;	1780992117
laravel-cache-livewire-rate-limiter:640e0040fc0bb5c2afa9ed62cf09c66754d690b5:timer	i:1781187208;	1781187208
laravel-cache-livewire-rate-limiter:640e0040fc0bb5c2afa9ed62cf09c66754d690b5	i:1;	1781187208
laravel-cache-livewire-rate-limiter:8527dd8aee574776c4b500351a0769c024ce8ca1:timer	i:1781223946;	1781223946
laravel-cache-livewire-rate-limiter:8527dd8aee574776c4b500351a0769c024ce8ca1	i:1;	1781223946
laravel-cache-livewire-rate-limiter:841d46ab7617f7b59f190aaa08605beac7f7bff2:timer	i:1781237719;	1781237719
laravel-cache-livewire-rate-limiter:841d46ab7617f7b59f190aaa08605beac7f7bff2	i:1;	1781237719
laravel-cache-livewire-rate-limiter:3f145e91384eb989a8633c639d3575773a022e53:timer	i:1781315057;	1781315057
laravel-cache-livewire-rate-limiter:3f145e91384eb989a8633c639d3575773a022e53	i:1;	1781315057
laravel-cache-livewire-rate-limiter:8e9f8c4a7c9b38f8b0f3e6756fb8817d08d105eb:timer	i:1781410520;	1781410520
laravel-cache-livewire-rate-limiter:8e9f8c4a7c9b38f8b0f3e6756fb8817d08d105eb	i:1;	1781410520
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: chat_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.chat_logs (id, agent_id, direction, channel, account_id, conversation_id, message_id, sender, content, success, error_msg, session_key, occurred_at, created_at, updated_at) FROM stdin;
1	test	inbound	telegram	\N	\N	\N	\N	测试消息	t	\N	\N	2026-04-07 07:51:00	2026-04-07 07:52:00	2026-04-07 07:52:00
2	\N	inbound	telegram	david2	telegram:7588358556	116	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:34:27	2026-04-07 08:34:27	2026-04-07 08:34:27
3	\N	outbound	telegram	david2	7588358556	117	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:01	2026-04-07 08:35:01	2026-04-07 08:35:01
4	\N	outbound	telegram	david2	7588358556	118	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:03	2026-04-07 08:35:03	2026-04-07 08:35:03
5	\N	outbound	telegram	david2	7588358556	119	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:04	2026-04-07 08:35:04	2026-04-07 08:35:04
6	\N	outbound	telegram	david2	7588358556	120	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:05	2026-04-07 08:35:05	2026-04-07 08:35:05
7	\N	outbound	telegram	david2	7588358556	121	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:06	2026-04-07 08:35:06	2026-04-07 08:35:06
8	\N	inbound	telegram	david2	telegram:7588358556	122	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:31	2026-04-07 08:35:31	2026-04-07 08:35:31
9	\N	outbound	telegram	david2	7588358556	123	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:58	2026-04-07 08:35:58	2026-04-07 08:35:58
10	\N	outbound	telegram	david2	7588358556	124	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:35:59	2026-04-07 08:35:59	2026-04-07 08:35:59
11	\N	outbound	telegram	david2	7588358556	125	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:36:00	2026-04-07 08:36:00	2026-04-07 08:36:00
12	\N	inbound	telegram	david2	telegram:7588358556	126	telegram:7588358556	好	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:36:28	2026-04-07 08:36:28	2026-04-07 08:36:28
13	\N	outbound	telegram	david2	7588358556	127	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:36:50	2026-04-07 08:36:50	2026-04-07 08:36:50
14	\N	outbound	telegram	david2	7588358556	128	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:36:52	2026-04-07 08:36:52	2026-04-07 08:36:52
15	\N	inbound	telegram	david2	telegram:7588358556	129	telegram:7588358556	好	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:36:56	2026-04-07 08:36:57	2026-04-07 08:36:57
16	david	inbound	telegram	david2	telegram:7588358556	130	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:37:36	2026-04-07 08:37:36	2026-04-07 08:37:36
17	david	outbound	telegram	david2	7588358556	131	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:37:58	2026-04-07 08:37:58	2026-04-07 08:37:58
18	david	outbound	telegram	david2	7588358556	132	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:38:00	2026-04-07 08:38:00	2026-04-07 08:38:00
19	david	inbound	telegram	david2	telegram:7588358556	133	telegram:7588358556	如何打包	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:38:35	2026-04-07 08:38:35	2026-04-07 08:38:35
20	david	outbound	telegram	david2	7588358556	134	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:38:48	2026-04-07 08:38:48	2026-04-07 08:38:48
21	david	outbound	telegram	david2	7588358556	135	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:38:50	2026-04-07 08:38:50	2026-04-07 08:38:50
22	david	inbound	telegram	david2	telegram:7588358556	136	telegram:7588358556	chat-logger-plugin.tgz 自带API_URL 和 API_TOKEN参数吗	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:43:09	2026-04-07 08:43:09	2026-04-07 08:43:09
23	david	outbound	telegram	david2	7588358556	137	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:43:19	2026-04-07 08:43:20	2026-04-07 08:43:20
24	david	inbound	telegram	david2	telegram:7588358556	138	telegram:7588358556	我如何下载chat-logger-plugin.tgz	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:44:56	2026-04-07 08:44:56	2026-04-07 08:44:56
25	david	outbound	telegram	david2	7588358556	139	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:45:07	2026-04-07 08:45:07	2026-04-07 08:45:07
26	david	inbound	telegram	david2	telegram:7588358556	140	telegram:7588358556	ssh	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:45:11	2026-04-07 08:45:12	2026-04-07 08:45:12
27	david	outbound	telegram	david2	7588358556	141	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:45:19	2026-04-07 08:45:19	2026-04-07 08:45:19
28	david	inbound	telegram	david2	telegram:7588358556	142	telegram:7588358556	在服务器执行呢	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:45:39	2026-04-07 08:45:40	2026-04-07 08:45:40
29	david	outbound	telegram	david2	7588358556	143	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:45:50	2026-04-07 08:45:50	2026-04-07 08:45:50
30	deepseek	inbound	telegram	deepseek	telegram:7588358556	94	telegram:7588358556	hi	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 00:55:24	2026-04-07 08:55:24	2026-04-07 08:55:24
31	deepseek	outbound	telegram	deepseek	7588358556	95	\N	\N	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 00:55:32	2026-04-07 08:55:32	2026-04-07 08:55:32
32	deepseek	inbound	telegram	deepseek	telegram:7588358556	96	telegram:7588358556	你在哪里	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 00:57:29	2026-04-07 08:57:30	2026-04-07 08:57:30
33	deepseek	outbound	telegram	deepseek	7588358556	97	\N	\N	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 00:57:36	2026-04-07 08:57:36	2026-04-07 08:57:36
34	david	inbound	telegram	david2	telegram:7588358556	144	telegram:7588358556	OpenClaw 发过来的 outbound 记录 content 就是 null，说明 OpenClaw 的 chat-logger plugin 写入时没有把 agent 回复内容映射到 content\n   字段。                                                                                                                         \n                                                                                                                                  \n  这是 plugin 配置问题，需要在 OpenClaw 那边检查 chat-logger-plugin 的字段映射——outbound 消息的正文用的是什么字段名？看一下       \n  /home/ubuntu/.openclaw/workspace/chat-logger-plugin.tgz 里的配置	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:58:52	2026-04-07 08:58:52	2026-04-07 08:58:52
35	david	outbound	telegram	david2	7588358556	145	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:59:12	2026-04-07 08:59:12	2026-04-07 08:59:12
36	david	outbound	telegram	david2	7588358556	146	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:59:13	2026-04-07 08:59:13	2026-04-07 08:59:13
37	david	outbound	telegram	david2	7588358556	147	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 00:59:14	2026-04-07 08:59:14	2026-04-07 08:59:14
38	david	inbound	telegram	david2	telegram:7588358556	148	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:08	2026-04-07 09:00:08	2026-04-07 09:00:08
39	david	outbound	telegram	david2	7588358556	149	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:45	2026-04-07 09:00:45	2026-04-07 09:00:45
40	david	outbound	telegram	david2	7588358556	150	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:47	2026-04-07 09:00:47	2026-04-07 09:00:47
41	david	outbound	telegram	david2	7588358556	151	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:48	2026-04-07 09:00:48	2026-04-07 09:00:48
42	david	outbound	telegram	david2	7588358556	152	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:49	2026-04-07 09:00:49	2026-04-07 09:00:49
43	david	outbound	telegram	david2	7588358556	153	\N	\N	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:00:50	2026-04-07 09:00:50	2026-04-07 09:00:50
44	david	inbound	telegram	david2	telegram:7588358556	154	telegram:7588358556	好了吗	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:01:12	2026-04-07 09:01:12	2026-04-07 09:01:12
45	david	outbound	telegram	david2	7588358556	155	\N	好了，看日志：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:01:39	2026-04-07 09:01:39	2026-04-07 09:01:39
46	david	outbound	telegram	david2	7588358556	156	\N	outbound 的字段是 `ctx.content`，内容完整有了！现在把 debug 日志去掉，handler 清理干净：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:01:40	2026-04-07 09:01:40	2026-04-07 09:01:40
47	david	outbound	telegram	david2	7588358556	157	\N	inbound 和 outbound 都用 `ctx.content`，完全一致。再把最新 handler 同步回源目录打包：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:01:41	2026-04-07 09:01:41	2026-04-07 09:01:41
48	david	outbound	telegram	david2	7588358556	158	\N	全部搞定 ✅ 重启一次让 debug 日志停掉：\n\n```bash\nsystemctl --user restart openclaw-gateway\n```	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:01:42	2026-04-07 09:01:42	2026-04-07 09:01:42
49	david	inbound	telegram	david2	telegram:7588358556	159	telegram:7588358556	测试一下	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:02:03	2026-04-07 09:02:03	2026-04-07 09:02:03
50	david	outbound	telegram	david2	7588358556	160	\N	已收到！等我回复后查数据库：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:02:31	2026-04-07 09:02:31	2026-04-07 09:02:31
51	david	outbound	telegram	david2	7588358556	161	\N	完美 ✅\n\n- `[inbound] agent=david | 测试一下` — 你的消息 ✅\n- `[outbound] agent=david | 全部搞定...` — 我的回复，内容完整 ✅\n\ninbound / outbound 内容都正确写入了，整套方案全部跑通！	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:02:32	2026-04-07 09:02:32	2026-04-07 09:02:32
52	deepseek	inbound	telegram	deepseek	telegram:7588358556	100	telegram:7588358556	ni好	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:04:13	2026-04-07 09:04:13	2026-04-07 09:04:13
53	deepseek	outbound	telegram	deepseek	7588358556	101	\N	🏪 你好David！我是舌尖门店AI助手，随时为您服务。\n\n现在是2026年4月7日早上9:04，湾仔店正在营业中。\n\n有什么需要我帮忙处理的吗？比如：\n- 查看当前库存情况\n- 补录销售情况（如"XX商品卖完了"）\n- 查看今日进货记录\n- 查看今日销售汇总\n- 录入新的进货信息\n- 或者其他门店管理操作	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:04:21	2026-04-07 09:04:21	2026-04-07 09:04:21
54	deepseek	inbound	telegram	deepseek	telegram:7588358556	104	telegram:7588358556	在吗	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:13:22	2026-04-07 09:13:22	2026-04-07 09:13:22
55	deepseek	inbound	telegram	deepseek	telegram:7588358556	106	telegram:7588358556	你在哪里	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:15:01	2026-04-07 09:15:01	2026-04-07 09:15:01
56	deepseek	outbound	telegram	deepseek	7588358556	107	\N	🏪 我是舌尖门店AI助手，运行在云端服务器上，专门为您的湾仔店提供远程管理服务。\n\n我的主要功能包括：\n- 📦 库存管理（查询、补录、调整）\n- 💰 销售补录与查询\n- 🚛 进货管理\n- 📊 门店运营数据分析\n\n无论您在哪里，只要通过Telegram联系我，我就能帮您管理门店的日常运营工作。\n\n现在有什么需要我帮您处理的吗？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:15:09	2026-04-07 09:15:09	2026-04-07 09:15:09
57	deepseek	inbound	telegram	deepseek	telegram:7588358556	109	telegram:7588358556	？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:16:02	2026-04-07 09:16:02	2026-04-07 09:16:02
58	deepseek	outbound	telegram	deepseek	7588358556	110	\N	抱歉，我可能没理解您的意思。您是想问什么吗？\n\n我是舌尖门店AI助手，专门帮您管理湾仔店的运营工作。我可以帮您：\n\n1. 📦 **库存管理**：查库存、补录销售、调整库存\n2. 💰 **销售管理**：查看销售汇总、补录销售情况\n3. 🚛 **进货管理**：录入进货、查看进货记录\n4. 📊 **数据分析**：查看每日概览、操作日志\n\n您具体想了解什么或者需要什么帮助呢？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:16:10	2026-04-07 09:16:10	2026-04-07 09:16:10
59	david	inbound	telegram	david2	telegram:7588358556	162	telegram:7588358556	重新打包	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:16:26	2026-04-07 09:16:27	2026-04-07 09:16:27
60	david	outbound	telegram	david2	7588358556	163	\N	打好了，路径：`/home/ubuntu/.openclaw/workspace-david/chat-logger-plugin.tgz`	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:16:39	2026-04-07 09:16:39	2026-04-07 09:16:39
61	david	inbound	telegram	david2	telegram:7588358556	164	telegram:7588358556	覆盖了吗	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:16:46	2026-04-07 09:16:46	2026-04-07 09:16:46
62	david	outbound	telegram	david2	7588358556	165	\N	覆盖了，刚才 `cp` 把最新的 handler.ts（已去掉 debug、content 字段已修正）同步到源目录再打包的，是最新版本。\n\n可以验证一下内容：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:16:57	2026-04-07 09:16:57	2026-04-07 09:16:57
63	david	outbound	telegram	david2	7588358556	166	\N	确认：\n- ✅ `content: ctx.content ?? null` — 正确字段\n- ✅ 无任何 debug 代码\n- ✅ API_URL 和 API_TOKEN 都在	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:16:58	2026-04-07 09:16:58	2026-04-07 09:16:58
64	david	inbound	telegram	david2	telegram:7588358556	167	telegram:7588358556	如果openclaw停止工作 不回复信息 如何设置重启呢	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:19:12	2026-04-07 09:19:12	2026-04-07 09:19:12
65	david	outbound	telegram	david2	7588358556	168	\N	Systemd 已经配了 `Restart=always`，进程崩溃会自动重启。但如果是卡死（进程还在但不响应），需要额外的看门狗机制。\n\n几个方案：\n\n---\n\n**方案1：加 watchdog cron（推荐）**\n\n每分钟检查一次，没响应就重启：\n\n```bash\ncrontab -e\n```\n\n加这行：\n```bash\n* * * * * /home/ubuntu/.npm-global/bin/openclaw gateway status 2>/dev/null | grep -q "RPC probe: ok" || systemctl --user restart openclaw-gateway\n```\n\n---\n\n**方案2：用 OpenClaw 自带的 healthcheck**\n\nOpenClaw 有内置 healthcheck 功能，可以定期自检。看看有没有相关配置：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:19:41	2026-04-07 09:19:41	2026-04-07 09:19:41
66	david	outbound	telegram	david2	7588358556	169	\N	OpenClaw 能检测 session stuck 但不会自动重启。**cron watchdog 是最实用的方案**，直接设置：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:19:42	2026-04-07 09:19:42	2026-04-07 09:19:42
67	david	outbound	telegram	david2	7588358556	170	\N	现在没有 crontab，帮你加上：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:19:43	2026-04-07 09:19:43	2026-04-07 09:19:43
68	david	outbound	telegram	david2	7588358556	171	\N	Gateway 掉了，需要你先重启：\n\n```bash\nsystemctl --user restart openclaw-gateway\n```\n\n重启好之后我继续帮你配 watchdog cron。	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:19:44	2026-04-07 09:19:44	2026-04-07 09:19:44
69	david	inbound	telegram	david2	telegram:7588358556	172	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:20:36	2026-04-07 09:20:36	2026-04-07 09:20:36
96	deepseek	outbound	telegram	deepseek	7588358556	126	\N	🏪 你好David！我在这里呢。需要我帮你处理什么门店事务吗？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:36:11	2026-04-07 10:36:11	2026-04-07 10:36:11
97	deepseek	inbound	telegram	deepseek	telegram:7588358556	127	telegram:7588358556	<media:image>	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:36:19	2026-04-07 10:36:22	2026-04-07 10:36:22
70	david	outbound	telegram	david2	7588358556	173	\N	Gateway 又掉了，看来不稳定。先在终端跑这几条命令：\n\n```bash\n# 1. 重启 gateway\nsystemctl --user restart openclaw-gateway\n\n# 2. 写 watchdog 脚本\ncat > /home/ubuntu/.openclaw/watchdog.sh << 'EOF'\n#!/bin/bash\nif ! /home/ubuntu/.npm-global/bin/openclaw gateway status 2>/dev/null | grep -q "RPC probe: ok"; then\n    echo "[$(date)] restarting..." >> /tmp/openclaw-watchdog.log\n    systemctl --user restart openclaw-gateway\nfi\nEOF\nchmod +x /home/ubuntu/.openclaw/watchdog.sh\n\n# 3. 加 crontab（每分钟检查）\n(crontab -l 2>/dev/null; echo "* * * * * /home/ubuntu/.openclaw/watchdog.sh") | crontab -\n\n# 4. 验证\ncrontab -l\n```\n\n四步一起跑完告诉我结果。	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:21:05	2026-04-07 09:21:05	2026-04-07 09:21:05
71	david	inbound	telegram	david2	telegram:7588358556	174	telegram:7588358556	你可以帮我跑吗	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:21:32	2026-04-07 09:21:32	2026-04-07 09:21:32
72	david	outbound	telegram	david2	7588358556	175	\N	可以，但需要你先批准，因为涉及写文件和修改 crontab：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:21:41	2026-04-07 09:21:41	2026-04-07 09:21:41
73	david	outbound	telegram	david2	7588358556	176	\N	Gateway 还是断开状态，审批通道也不通。需要你先在终端手动重启：\n\n```bash\nsystemctl --user restart openclaw-gateway\n```\n\n重启好了之后我立刻帮你跑剩下的。	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:21:43	2026-04-07 09:21:43	2026-04-07 09:21:43
74	david	inbound	telegram	david2	telegram:7588358556	177	telegram:7588358556	重启了	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:22:04	2026-04-07 09:22:04	2026-04-07 09:22:04
75	david	outbound	telegram	david2	7588358556	178	\N	Gateway 刚重启完还没 pair 上，等几秒再试：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:22:36	2026-04-07 09:22:36	2026-04-07 09:22:36
76	david	outbound	telegram	david2	7588358556	179	\N	好了，现在跑：	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:22:38	2026-04-07 09:22:38	2026-04-07 09:22:38
77	david	outbound	telegram	david2	7588358556	180	\N	奇怪，RPC 刚才还是 ok 的。这个错误不是 gateway 的问题，是我这边的执行权限被 gateway pairing 拦住了。\n\n直接在你终端跑这三条：\n\n```bash\ncat > /home/ubuntu/.openclaw/watchdog.sh << 'EOF'\n#!/bin/bash\nif ! /home/ubuntu/.npm-global/bin/openclaw gateway status 2>/dev/null | grep -q "RPC probe: ok"; then\n    echo "[$(date)] restarting..." >> /tmp/openclaw-watchdog.log\n    systemctl --user restart openclaw-gateway\nfi\nEOF\n\nchmod +x /home/ubuntu/.openclaw/watchdog.sh\n\n(crontab -l 2>/dev/null; echo "* * * * * /home/ubuntu/.openclaw/watchdog.sh") | crontab -\n```\n\n完成后 `crontab -l` 看一下结果告诉我。	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:22:39	2026-04-07 09:22:39	2026-04-07 09:22:39
78	david	inbound	telegram	david2	telegram:7588358556	181	telegram:7588358556	* * * * * /home/ubuntu/.openclaw/watchdog.sh	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:23:06	2026-04-07 09:23:06	2026-04-07 09:23:06
79	david	outbound	telegram	david2	7588358556	182	\N	完美 ✅ \n\nwatchdog 已生效，每分钟自动检查一次。如果 gateway 不响应就自动重启，重启记录会写到 `/tmp/openclaw-watchdog.log`。\n\n以后可以用这个看重启历史：\n```bash\ncat /tmp/openclaw-watchdog.log\n```	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:23:13	2026-04-07 09:23:13	2026-04-07 09:23:13
80	david	inbound	telegram	david2	telegram:7588358556	183	telegram:7588358556	好	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:23:33	2026-04-07 09:23:33	2026-04-07 09:23:33
81	david	outbound	telegram	david2	7588358556	184	\N	今天搞定了不少东西，总结一下：\n\n**✅ 完成清单**\n- `chat-logger` plugin — 所有 agent 收发消息自动写入 Laravel MySQL\n- inbound / outbound 内容完整，agent_id 正确\n- watchdog cron — 每分钟检查，gateway 挂了自动重启\n- 打包好了 `chat-logger-plugin.tgz`，给新客户两条命令装好\n\n有其他问题随时找我。	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 01:23:41	2026-04-07 09:23:41	2026-04-07 09:23:41
82	deepseek	inbound	telegram	deepseek	telegram:7588358556	111	telegram:7588358556	你好	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:25:28	2026-04-07 09:25:28	2026-04-07 09:25:28
83	deepseek	outbound	telegram	deepseek	7588358556	112	\N	🏪 你好David！我是舌尖门店AI助手，随时为您服务。\n\n现在是2026年4月7日早上9:25，湾仔店正在营业中。\n\n有什么需要我帮忙处理的吗？比如：\n- 查看当前库存情况\n- 补录销售情况（如"XX商品卖完了"）\n- 查看今日进货记录\n- 查看今日销售汇总\n- 录入新的进货信息\n- 或者其他门店管理操作	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:25:37	2026-04-07 09:25:37	2026-04-07 09:25:37
84	deepseek	inbound	telegram	deepseek	telegram:7588358556	113	telegram:7588358556	/help	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-07 01:25:40	2026-04-07 09:25:40	2026-04-07 09:25:40
85	deepseek	outbound	telegram	deepseek	7588358556	114	\N	ℹ️ Help\n\nSession\n  /new  |  /reset  |  /compact [instructions]  |  /stop\n\nOptions\n  /think <level>  |  /model <id>  |  /fast status|on|off  |  /verbose on|off\n\nStatus\n  /status  |  /tasks  |  /whoami  |  /context\n\nSkills\n  /skill <name> [input]\n\nMore: /commands for full list, /tools for available capabilities	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-07 01:25:40	2026-04-07 09:25:40	2026-04-07 09:25:40
86	deepseek	inbound	telegram	deepseek	telegram:7588358556	115	telegram:7588358556	/new	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-07 01:25:42	2026-04-07 09:25:42	2026-04-07 09:25:42
87	deepseek	outbound	telegram	deepseek	telegram:7588358556	116	\N	✅ New session started · model: deepseek/deepseek-chat	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:25:45	2026-04-07 09:25:45	2026-04-07 09:25:45
88	deepseek	outbound	telegram	deepseek	7588358556	118	\N	🏪 嗨David！我是舌尖门店AI助手，刚刚上线。今天有什么需要我帮忙处理的吗？比如库存查询、销售补录，还是其他门店管理事务？	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-07 01:25:50	2026-04-07 09:25:50	2026-04-07 09:25:50
89	deepseek	inbound	telegram	deepseek	telegram:7588358556	117	telegram:7588358556	你好	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:25:50	2026-04-07 09:25:50	2026-04-07 09:25:50
90	deepseek	outbound	telegram	deepseek	7588358556	119	\N	🏪 你好David！我是你的舌尖门店AI助手，专门处理门店管理事务。今天需要我帮你做什么呢？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 01:25:57	2026-04-07 09:25:57	2026-04-07 09:25:57
91	main	inbound	telegram	david	telegram:7588358556	120	telegram:7588358556	你好	t	\N	agent:main:telegram:david:direct:7588358556	2026-04-07 01:42:29	2026-04-07 09:42:30	2026-04-07 09:42:30
92	main	outbound	telegram	david	7588358556	121	\N	你好！有什么需要帮的？	t	\N	agent:main:telegram:david:direct:7588358556	2026-04-07 01:42:33	2026-04-07 09:42:33	2026-04-07 09:42:33
93	deepseek	inbound	telegram	deepseek	telegram:7588358556	120	telegram:7588358556	你好	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:33:59	2026-04-07 10:33:59	2026-04-07 10:33:59
94	deepseek	outbound	telegram	deepseek	7588358556	121	\N	🏪 你好David！有什么需要我帮忙的门店管理事务吗？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:34:03	2026-04-07 10:34:03	2026-04-07 10:34:03
95	deepseek	inbound	telegram	deepseek	telegram:7588358556	125	telegram:7588358556	你好	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:36:06	2026-04-07 10:36:06	2026-04-07 10:36:06
98	deepseek	outbound	telegram	deepseek	7588358556	128	\N	我看到你发送了一张图片，但我目前无法查看图片内容。如果你需要我处理门店相关的图片（比如库存清单、销售单据等），你可以描述一下图片内容，或者告诉我需要我帮你做什么具体的事情。\n\n比如：\n- 需要记录进货信息？\n- 需要查询某个商品的库存？\n- 需要补录销售数据？\n- 其他门店管理事务？\n\n请告诉我具体需求，我会尽力帮你处理！🏪	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-07 02:36:31	2026-04-07 10:36:31	2026-04-07 10:36:31
99	david	inbound	telegram	david2	telegram:7588358556	185	telegram:7588358556	/new	t	\N	agent:david:telegram:slash:7588358556	2026-04-07 02:38:35	2026-04-07 10:38:36	2026-04-07 10:38:36
100	david	outbound	telegram	david2	telegram:7588358556	186	\N	✅ New session started · model: api10-xingke888-com/claude-sonnet-4-6	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 02:38:39	2026-04-07 10:38:39	2026-04-07 10:38:39
101	david	outbound	telegram	david2	7588358556	188	\N	哈，又开门了！我是舌尖生鲜店的店员，今天有什么需要？🥬	t	\N	agent:david:telegram:slash:7588358556	2026-04-07 02:38:47	2026-04-07 10:38:47	2026-04-07 10:38:47
102	david	inbound	telegram	david2	telegram:7588358556	187	telegram:7588358556	企业微信可以对接龙虾吗	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 02:38:47	2026-04-07 10:38:47	2026-04-07 10:38:47
103	david	outbound	telegram	david2	7588358556	189	\N	可以的！企业微信可以通过以下方式对接龙虾（接龙）：\n\n**方式一：企业微信内置接龙**\n企业微信群本身支持"接龙"功能，在群聊里点击「+」→「接龙」就能发起，不需要额外对接。\n\n**方式二：对接龙虾接龙小程序/服务**\n如果是龙虾接龙这个第三方平台，可以通过：\n- **企业微信服务商接入**：龙虾接龙有企业微信版本，可以作为第三方应用挂载到企业微信上\n- **Webhook机器人**：在企业微信群里配置机器人，接收龙虾的回调消息\n\n**你具体想做什么场景？** 比如：\n- 团购/拼单接龙？\n- 活动报名接龩？\n- 还是想把接龙数据同步到企业微信？\n\n说清楚需求，我帮你想最合适的方案 😊	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 02:38:58	2026-04-07 10:38:58	2026-04-07 10:38:58
104	david	inbound	telegram	david2	telegram:7588358556	190	telegram:7588358556	好	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 02:42:48	2026-04-07 10:42:49	2026-04-07 10:42:49
105	david	outbound	telegram	david2	7588358556	191	\N	那你现在用的是哪种场景？团购接龙、活动报名、还是别的？方便我给你更具体的对接方案 😄	t	\N	agent:david:telegram:direct:7588358556	2026-04-07 02:42:55	2026-04-07 10:42:55	2026-04-07 10:42:55
106	david	inbound	telegram	david2	telegram:7588358556	192	telegram:7588358556	你好	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:50:36	2026-04-08 20:50:36	2026-04-08 20:50:36
107	david	outbound	telegram	david2	7588358556	193	\N	你好！有什么需要吗？😊	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:50:42	2026-04-08 20:50:42	2026-04-08 20:50:42
108	david	inbound	telegram	david2	telegram:7588358556	194	telegram:7588358556	今天的库存是多少	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:50:52	2026-04-08 20:50:52	2026-04-08 20:50:52
109	david	outbound	telegram	david2	7588358556	195	\N	我这边没有库存数据的访问权限，你需要查哪个品类的库存？我帮你想想怎么查 😄\n\n还是说你们有个系统/表格，需要我帮你对接或者查询？	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:50:59	2026-04-08 20:50:59	2026-04-08 20:50:59
110	deepseek	inbound	telegram	deepseek	telegram:7588358556	129	telegram:7588358556	今天库存	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:51:46	2026-04-08 20:51:46	2026-04-08 20:51:46
111	deepseek	outbound	telegram	deepseek	7588358556	130	\N	🏪 好的，我来帮你查看今天的库存情况。\n\n不过我需要先了解一下你的库存管理系统是如何设置的。你可以告诉我：\n\n1. **库存数据存储在哪里？**\n   - Excel文件？\n   - 数据库？\n   - 其他系统？\n\n2. **需要查看哪些信息？**\n   - 所有商品库存列表？\n   - 低库存预警商品？\n   - 特定品类库存？\n   - 库存变化记录？\n\n如果你有库存文件，可以上传给我，或者告诉我文件路径，我来帮你分析。	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:51:55	2026-04-08 20:51:55	2026-04-08 20:51:55
112	david	inbound	telegram	david2	telegram:7588358556	196	telegram:7588358556	OpenClaw: access not configured.\n\nYour Telegram user id: 7588358556\nPairing code:\n\nP886W3SZ\n\nAsk the bot owner to approve with:\nopenclaw pairing approve telegram P886W3SZ\n\nopenclaw pairing approve telegram P886W3SZ	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:52:30	2026-04-08 20:52:30	2026-04-08 20:52:30
113	david	outbound	telegram	david2	7588358556	197	\N	这条是系统配对提示，不是发给我的消息 😄\n\n看起来你在尝试把某个 Telegram 账号和 OpenClaw 配对。你需要让机器人的管理员运行这条命令：\n\n```\nopenclaw pairing approve telegram P886W3SZ\n```\n\n你是管理员吗？需要我帮你操作吗？	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:52:38	2026-04-08 20:52:38	2026-04-08 20:52:38
114	david	inbound	telegram	david2	telegram:7588358556	198	telegram:7588358556	是	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:52:40	2026-04-08 20:52:40	2026-04-08 20:52:40
115	david	outbound	telegram	david2	7588358556	199	\N	配对码 `P886W3SZ` 已过期或不存在了。你重新发起一下配对，让系统生成新的配对码，我再帮你批准 😊	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:52:56	2026-04-08 20:52:56	2026-04-08 20:52:56
116	david	inbound	telegram	david2	telegram:7588358556	200	telegram:7588358556	在	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:53:39	2026-04-08 20:53:39	2026-04-08 20:53:39
117	david	outbound	telegram	david2	7588358556	201	\N	新的配对码发过来了吗？把码告诉我，我帮你批准 😄	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:53:43	2026-04-08 20:53:44	2026-04-08 20:53:44
118	david	inbound	telegram	david2	telegram:7588358556	202	telegram:7588358556	8387934942:AAETUYTYSNJFZitk7I2WT96NVLunVI9PoqQ	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:54:06	2026-04-08 20:54:07	2026-04-08 20:54:07
119	david	outbound	telegram	david2	7588358556	203	\N	这个看起来是 Telegram Bot Token，不是配对码！⚠️\n\n**千万不要把这个发给任何人**，这是你机器人的密钥，泄露了别人可以控制你的 bot。\n\n建议你马上去 [@BotFather](https://t.me/BotFather) 重置这个 token：\n1. 发送 `/mybots`\n2. 选择你的 bot\n3. 点 **API Token** → **Revoke current token**\n\n配对码是类似 `P886W3SZ` 这样的短码，不是长串的 token。重新触发配对流程会生成新的短码给你 😊	t	\N	agent:david:telegram:direct:7588358556	2026-04-08 12:54:16	2026-04-08 20:54:16	2026-04-08 20:54:16
120	deepseek	inbound	telegram	deepseek	telegram:7588358556	136	telegram:7588358556	排队	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:54:44	2026-04-08 20:54:44	2026-04-08 20:54:44
145	main	inbound	whatsapp	default	+85262645180	3B403F8FC840E8DC0FF1	+85262645180	其他OpenAI兼容的API	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:07	2026-04-18 07:29:07	2026-04-18 07:29:07
167	main	inbound	webchat	\N	\N	1fb3c2ff-b596-4a83-b264-d727c4423239	\N	shejian	t	\N	agent:main:main	2026-04-17 23:39:28	2026-04-18 07:39:28	2026-04-18 07:39:28
168	main	inbound	whatsapp	default	+85262645180	3BB383083382F8BF92B8	+85262645180	/skills	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:40:07	2026-04-18 07:40:07	2026-04-18 07:40:07
121	deepseek	outbound	telegram	deepseek	7588358556	137	\N	🏪 明白了，你想了解门店的排队情况。我需要更多信息来帮你：\n\n1. **排队系统类型：**\n   - 是实体店顾客排队？\n   - 外卖订单排队？\n   - 线上预约排队？\n\n2. **需要查看什么：**\n   - 当前排队人数？\n   - 预计等待时间？\n   - 排队订单列表？\n   - 处理进度？\n\n3. **数据来源：**\n   - 排队系统软件？\n   - 手动记录？\n   - 监控摄像头？\n\n如果你有排队数据文件或系统截图，可以上传给我，或者告诉我如何访问相关数据。	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:54:53	2026-04-08 20:54:54	2026-04-08 20:54:54
122	deepseek	inbound	telegram	deepseek	telegram:7588358556	138	telegram:7588358556	配对	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:54:54	2026-04-08 20:54:54	2026-04-08 20:54:54
123	deepseek	outbound	telegram	deepseek	7588358556	139	\N	🏪 配对？让我确认一下你的意思：\n\n1. **商品配对？** - 比如搭配销售的商品组合\n2. **员工排班配对？** - 员工工作班次安排\n3. **库存配对？** - 库存与销售数据的匹配\n4. **其他配对需求？**\n\n请具体说明你需要什么类型的配对，或者上传相关文件让我帮你处理。	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:55:02	2026-04-08 20:55:02	2026-04-08 20:55:02
124	deepseek	inbound	telegram	deepseek	telegram:7588358556	140	telegram:7588358556	查一下今天的库存	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:55:05	2026-04-08 20:55:05	2026-04-08 20:55:05
125	deepseek	outbound	telegram	deepseek	7588358556	141	\N	🏪 好的，我来帮你查看今天的库存。\n\n不过我需要先找到库存数据。让我检查一下工作空间里是否有相关的库存文件：	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:55:25	2026-04-08 20:55:25	2026-04-08 20:55:25
126	deepseek	outbound	telegram	deepseek	7588358556	142	\N	让我查看工作空间目录结构，看看有没有库存相关的文件：	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:55:27	2026-04-08 20:55:27	2026-04-08 20:55:27
127	deepseek	outbound	telegram	deepseek	7588358556	143	\N	我看到工作空间里没有库存文件。David，我需要你提供库存数据才能帮你查看。你可以：\n\n1. **上传库存文件**（Excel、CSV等格式）\n2. **告诉我库存数据在哪里**（文件路径或系统）\n3. **描述一下库存系统**（我帮你建立库存管理）\n\n或者，如果你希望我从头开始帮你建立库存管理系统，我可以：\n- 创建库存模板文件\n- 设置库存分类\n- 建立库存记录流程\n\n请告诉我你希望如何操作？🏪	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 12:55:28	2026-04-08 20:55:28	2026-04-08 20:55:28
128	deepseek	inbound	telegram	deepseek	telegram:7588358556	145	telegram:7588358556	/help	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-08 12:55:55	2026-04-08 20:55:55	2026-04-08 20:55:55
129	deepseek	outbound	telegram	deepseek	7588358556	146	\N	ℹ️ Help\n\nSession\n  /new  |  /reset  |  /compact [instructions]  |  /stop\n\nOptions\n  /think <level>  |  /model <id>  |  /fast status|on|off  |  /verbose on|off\n\nStatus\n  /status  |  /tasks  |  /whoami  |  /context\n\nSkills\n  /skill <name> [input]\n\nMore: /commands for full list, /tools for available capabilities	t	\N	agent:deepseek:telegram:slash:7588358556	2026-04-08 12:55:55	2026-04-08 20:55:55	2026-04-08 20:55:55
130	deepseek	inbound	telegram	deepseek	telegram:7588358556	147	telegram:7588358556	库存	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 15:48:20	2026-04-08 23:48:20	2026-04-08 23:48:20
131	deepseek	outbound	telegram	deepseek	7588358556	148	\N	🏪 我理解你想查看库存，但目前工作空间里没有库存数据文件。\n\n让我为你创建一个简单的库存管理模板，这样你就可以开始记录库存了：	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 15:48:50	2026-04-08 23:48:50	2026-04-08 23:48:50
132	deepseek	outbound	telegram	deepseek	7588358556	149	\N	🏪 我已经为你创建了一个库存管理模板，包含10种常见生鲜商品。\n\n**当前库存概览：**\n1. **鲜牛肉** - 50包（安全库存：20）\n2. **三文鱼** - 30盒（安全库存：15）  \n3. **基围虾** - 25盒（安全库存：10）\n4. **西兰花** - 40包（安全库存：15）\n5. **鸡蛋** - 60盒（安全库存：25）\n6. **牛奶** - 35瓶（安全库存：12）\n7. **苹果** - 45袋（安全库存：20）\n8. **大米** - 20袋（安全库存：8）\n9. **食用油** - 15桶（安全库存：6）\n10. **酱油** - 25瓶（安全库存：10）\n\n**低库存预警：** 目前所有商品库存都高于安全库存线 ✅\n\n你可以：\n1. **上传你的实际库存文件**（替换这个模板）\n2. **让我分析特定商品的库存情况**\n3. **更新库存数量**\n4. **添加新商品**\n\n请告诉我你需要什么操作？	t	\N	agent:deepseek:telegram:direct:7588358556	2026-04-08 15:48:52	2026-04-08 23:48:52	2026-04-08 23:48:52
133	david	inbound	telegram	david2	telegram:7588358556	204	telegram:7588358556	/new	t	\N	agent:david:telegram:slash:7588358556	2026-04-11 00:49:45	2026-04-11 08:49:45	2026-04-11 08:49:45
134	david	outbound	telegram	david2	telegram:7588358556	205	\N	✅ New session started · model: api10-xingke888-com/claude-sonnet-4-6	t	\N	agent:david:telegram:direct:7588358556	2026-04-11 00:49:48	2026-04-11 08:49:48	2026-04-11 08:49:48
135	david	outbound	telegram	david2	7588358556	206	\N	早上好，David！我是舌尖生鲜店的小助手，今天有什么需要帮忙的？🥬	t	\N	agent:david:telegram:slash:7588358556	2026-04-11 00:49:57	2026-04-11 08:49:57	2026-04-11 08:49:57
136	david	inbound	telegram	david2	telegram:7588358556	207	telegram:7588358556	微信ClawBot\n在微信中与OpenClaw 收发消息\n#在运行OpenClaw的设备安装插件，并开始与微信连接。\nnpx -y @tencent-weixin/openclaw-weixin-cli@latest install\n\n使用微信扫描展示的二维码，启用微信ClawBot插件后即可使用。	t	\N	agent:david:telegram:direct:7588358556	2026-04-11 00:50:06	2026-04-11 08:50:07	2026-04-11 08:50:07
137	david	outbound	telegram	david2	7588358556	208	\N	看起来你想在微信里接入 OpenClaw！来跑一下安装命令：	t	\N	agent:david:telegram:direct:7588358556	2026-04-11 00:52:22	2026-04-11 08:52:22	2026-04-11 08:52:22
138	david	outbound	telegram	david2	7588358556	209	\N	二维码出来了！用微信扫一下：\n\n**或者直接点这个链接扫码：**\nhttps://liteapp.weixin.qq.com/q/7GiQu1?qrcode=2b4ddb1f549db0a34559e6bd3758f3e3&bot_type=3\n\n扫完告诉我结果，我继续看进度。	t	\N	agent:david:telegram:direct:7588358556	2026-04-11 00:52:23	2026-04-11 08:52:23	2026-04-11 08:52:23
139	main	inbound	webchat	\N	\N	c04a9a07-3018-458d-8085-94d98de05665	\N	Wake up, my friend!	t	\N	agent:main:main	2026-04-17 23:26:35	2026-04-18 07:26:35	2026-04-18 07:26:35
140	main	inbound	whatsapp	default	+85262645180	AC05EA35DFC206C468141C1E69130D99	+85262645180	hi	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:26:43	2026-04-18 07:26:43	2026-04-18 07:26:43
141	main	inbound	whatsapp	default	+85262645180	ACF36D027D91CA3569FE6A69FE049706	+85262645180	/model	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:26:59	2026-04-18 07:26:59	2026-04-18 07:26:59
142	main	inbound	whatsapp	default	+85262645180	3BF47581DB9A0C8EAE14	+85262645180	添加model	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:27:37	2026-04-18 07:27:37	2026-04-18 07:27:37
143	main	inbound	whatsapp	default	+85262645180	3B9AB89C28A40E6A7323	+85262645180	1	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:27:52	2026-04-18 07:27:52	2026-04-18 07:27:52
144	main	inbound	whatsapp	default	+85262645180	3B1ED6B39E49A4AB506E	+85262645180	https://api10.xingke888.com	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:28:23	2026-04-18 07:28:23	2026-04-18 07:28:23
146	main	outbound	whatsapp	default	+85262645180	3EB0DC0D4B8BFA2AC7A76F	\N	我看到你提供了一个API端点：`https://api10.xingke888.com`。这看起来是一个自定义的API服务。\n\n要添加这个模型到OpenClaw，我需要知道：\n\n1. **这是什么类型的模型API？** 是OpenAI兼容的API吗？\n2. **需要API密钥吗？** 如果有，是什么格式？\n3. **模型名称是什么？** 比如 "gpt-4", "claude-3", 或者其他名称？\n\n让我先尝试检查这个API端点，看看它提供什么信息：	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:22	2026-04-18 07:29:26	2026-04-18 07:29:26
147	main	outbound	whatsapp	default	+85262645180	3EB02D77337556322A1B10	\N	这个API需要认证。让我看看OpenClaw如何配置自定义的OpenAI兼容API。首先检查配置文件：	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:26	2026-04-18 07:29:26	2026-04-18 07:29:26
148	main	outbound	whatsapp	default	+85262645180	3EB0A8E6FB80E5C8C1ADBA	\N	很好！我看到配置文件结构。现在我需要知道关于你的API的更多信息。请告诉我：\n\n1. **API提供商名称**：你想叫什么名字？比如 "xingke" 或 "custom-api"\n2. **API密钥**：如果有的话，是什么？\n3. **支持的模型**：这个API端点提供哪些模型？比如 "gpt-3.5-turbo", "gpt-4" 等\n4. **API类型**：是OpenAI兼容的API吗？\n\n如果你不确定，我可以帮你测试这个API端点。你需要提供API密钥吗？或者这是一个公开的API？\n\n另外，让我检查一下OpenClaw的模型配置文档：	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:26	2026-04-18 07:29:26	2026-04-18 07:29:26
149	main	outbound	whatsapp	default	+85262645180	3EB0C49793D8D57777700B	\N	让我用更简单的方式检查如何添加自定义模型。根据配置文件，我需要：\n\n1. 在 `models.providers` 中添加新的提供商\n2. 在 `auth.profiles` 中添加认证信息\n3. 更新 `agents.defaults.models` 来设置别名\n\n**请先回答这些问题：**\n\n1. 这个 `https://api10.xingke888.com` API需要API密钥吗？如果需要，是什么格式？\n2. 它支持哪些具体的模型？（比如调用时使用的模型ID）\n3. 这是OpenAI兼容的API吗？（通常以 `/v1/chat/completions` 结尾）\n\n如果你有API密钥，我可以帮你测试一下这个API是否工作正常。	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:26	2026-04-18 07:29:26	2026-04-18 07:29:26
150	main	outbound	whatsapp	default	+85262645180	3EB0A50B55AE429644333E	\N	好的，你想添加一个OpenAI兼容的API。你提供的 `https://api10.xingke888.com` 看起来就是这样的API。\n\n要配置这个API，我需要以下信息：\n\n## 必需的信息：\n\n1. **API密钥**：这个API需要什么格式的密钥？\n   - 通常是 `sk-` 开头的字符串\n   - 或者是Bearer token格式\n\n2. **模型名称**：这个API提供哪些模型？\n   - 比如：`gpt-3.5-turbo`, `gpt-4`, `claude-3-sonnet` 等\n   - 或者自定义的模型名称\n\n## 如果你不确定，我可以帮你测试：\n\n如果你有API密钥，我可以测试一下这个API是否正常工作：\n\n```bash\ncurl -X POST https://api10.xingke888.com/v1/chat/completions \\\n  -H "Content-Type: application/json" \\\n  -H "Authorization: Bearer YOUR_API_KEY" \\\n  -d '{\n    "model": "gpt-3.5-turbo",\n    "messages": [{"role": "user", "content": "Hello"}],\n    "max_tokens": 10\n  }'\n```\n\n## 配置步骤：\n\n一旦有了这些信息，我会：\n\n1. **更新配置文件**，添加新的提供商\n2. **设置认证信息**\n3. **添加模型别名**\n4. **测试连接**\n\n**请提供：**\n- API密钥（如果有）\n- 可用的模型名称列表\n\n或者，如果你希望我直接尝试配置，我可以先假设一些常见的设置，然后我们根据错误信息调整。	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:29:46	2026-04-18 07:29:46	2026-04-18 07:29:46
151	main	inbound	whatsapp	default	+85262645180	3B712857E7F5F347775F	+85262645180	sdfsf8is89dfs7dhfiusdfh89sfhisufhkjs8f9dfiso89ewf	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:30:00	2026-04-18 07:30:01	2026-04-18 07:30:01
152	main	inbound	whatsapp	default	+85262645180	3BA0470CF294EBF33D4D	+85262645180	这是API 密钥	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:30:23	2026-04-18 07:30:23	2026-04-18 07:30:23
153	main	inbound	whatsapp	default	+85262645180	3BD52F132D999426EF74	+85262645180	测试一下	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:31:02	2026-04-18 07:31:02	2026-04-18 07:31:02
154	main	inbound	whatsapp	default	+85262645180	3BC55824E5CDEA0903E5	+85262645180	https://api10.xingke888.com/	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:31:57	2026-04-18 07:31:57	2026-04-18 07:31:57
155	main	inbound	whatsapp	default	+85262645180	3B6E2343AB45F5066B64	+85262645180	key is sdfsf8is89dfs7dhfiusdfh89sfhisufhkjs8f9dfiso89ewf	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:32:29	2026-04-18 07:32:29	2026-04-18 07:32:29
156	main	outbound	whatsapp	default	+85262645180	3EB0C7F4270BF70C087E06	\N	好的，我已经测试了API端点 `https://api10.xingke888.com/` 和密钥 `sdfsf8is89dfs7dhfiusdfh89sfhisufhkjs8f9dfiso89ewf`。\n\n从测试结果来看：\n1. **API是Anthropic兼容的** - 根端点显示"Anthropic API"\n2. **认证有效** - API接受提供的密钥\n3. **主要问题是模型名称** - 所有测试的标准模型名称都返回"not_found_error"\n\n**现在我需要知道：**\n这个API支持哪些具体的模型名称？常见的测试都失败了，所以这个API可能使用非标准的模型命名。\n\n**请提供以下之一：**\n1. 这个API支持的模型名称列表\n2. API文档链接\n3. 或者，如果你有使用这个API的代码示例，我可以从中提取模型名称\n\n**或者，我们可以尝试：**\n1. 联系API提供商获取支持的模型列表\n2. 尝试一些可能的模型名称变体\n\n你能提供更多关于这个API的信息吗？比如：\n- 它是哪个公司/服务提供的？\n- 它主要支持哪些AI模型？\n- 你有没有使用过这个API的成功示例？	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:33:07	2026-04-18 07:33:07	2026-04-18 07:33:07
157	main	inbound	whatsapp	default	+85262645180	3B9E21D4E6984F6AEDAC	+85262645180	claude-sonnet-4-6	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:33:39	2026-04-18 07:33:39	2026-04-18 07:33:39
158	main	inbound	whatsapp	default	+85262645180	3BC63EEEDCE7B0846F3E	+85262645180	claude-haiku-4-5-20251001	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:35:38	2026-04-18 07:35:38	2026-04-18 07:35:38
159	main	inbound	whatsapp	default	+85262645180	3BE66D25EFDACF96FC4E	+85262645180	claude-sonnet-4-6[1m]	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:36:01	2026-04-18 07:36:01	2026-04-18 07:36:01
160	main	inbound	webchat	\N	\N	94bbeb84-b1bd-4df9-a663-a407170244e2	\N	hi	t	\N	agent:main:main	2026-04-17 23:36:40	2026-04-18 07:36:40	2026-04-18 07:36:40
161	main	inbound	webchat	\N	\N	28f8410c-cd08-45a4-bee3-6246e0e7b0ff	\N	hi	t	\N	agent:main:main	2026-04-17 23:37:00	2026-04-18 07:37:00	2026-04-18 07:37:00
162	main	inbound	whatsapp	default	+85262645180	3B34B1CE18ECA4FF6C51	+85262645180	/model xingke/claude-sonnet-4-6	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:37:28	2026-04-18 07:37:28	2026-04-18 07:37:28
163	main	inbound	whatsapp	default	+85262645180	3B1FE511DD84F05BBDF6	+85262645180	hi	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:37:33	2026-04-18 07:37:33	2026-04-18 07:37:33
164	main	inbound	whatsapp	default	+85262645180	3B10018D3A9B1574543E	+85262645180	/skills	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:37:51	2026-04-18 07:37:51	2026-04-18 07:37:51
165	main	inbound	webchat	\N	\N	eff08d1a-a55a-4126-a213-8c271a2ae523	\N	/skills	t	\N	agent:main:main	2026-04-17 23:38:15	2026-04-18 07:38:15	2026-04-18 07:38:15
166	main	inbound	webchat	\N	\N	6507e1ba-fe32-44ae-851d-88ff5726caef	\N	如何删除一个skill	t	\N	agent:main:main	2026-04-17 23:38:52	2026-04-18 07:38:52	2026-04-18 07:38:52
169	main	inbound	whatsapp	default	+85262645180	3B282E296445E80A5892	+85262645180	shejian	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:40:25	2026-04-18 07:40:25	2026-04-18 07:40:25
170	main	inbound	whatsapp	default	+85262645180	3BFA693F24BEB4A5D986	+85262645180	安装skill https://github.com/xingke2023/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:41:08	2026-04-18 07:41:08	2026-04-18 07:41:08
171	main	inbound	whatsapp	default	+85262645180	3B2C707485A4E4DB2F17	+85262645180	/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:41:42	2026-04-18 07:41:42	2026-04-18 07:41:42
172	main	inbound	whatsapp	default	+85262645180	3BBDD0766BED69791C8E	+85262645180	注册	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:41:59	2026-04-18 07:41:59	2026-04-18 07:41:59
173	main	inbound	whatsapp	default	+85262645180	3B0DC2D219065D12DFCD	+85262645180	mark	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:42:15	2026-04-18 07:42:15	2026-04-18 07:42:15
174	main	inbound	whatsapp	default	+85262645180	3B6A96B48BBFFF942A52	+85262645180	uuuu8888	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:42:22	2026-04-18 07:42:23	2026-04-18 07:42:23
175	main	inbound	whatsapp	default	+85262645180	3B6A3E99DDE160FFBB36	+85262645180	/new	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:43:05	2026-04-18 07:43:05	2026-04-18 07:43:05
176	main	outbound	whatsapp	default	+85262645180	3EB04CDFA4EC6B72B33346	\N	✅ New session started · model: xingke/claude-sonnet-4-6 (default: deepseek/deepseek-chat)	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:43:09	2026-04-18 07:43:11	2026-04-18 07:43:11
177	main	inbound	whatsapp	default	+85262645180	3B9B13FC2589AB2472E4	+85262645180	安装skill https://github.com/xingke2023/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:44:48	2026-04-18 07:44:49	2026-04-18 07:44:49
178	main	inbound	whatsapp	default	+85262645180	3B05D7951E242D0AF691	+85262645180	/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:45:16	2026-04-18 07:45:16	2026-04-18 07:45:16
179	main	inbound	whatsapp	default	+85262645180	3BB6E0E5C5C795B7A721	+85262645180	登录账号	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:45:34	2026-04-18 07:45:34	2026-04-18 07:45:34
180	main	inbound	whatsapp	default	+85262645180	3B3719DBC1A35E2DFE84	+85262645180	mark uuuu8888	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:45:45	2026-04-18 07:45:45	2026-04-18 07:45:45
181	main	inbound	whatsapp	default	+85262645180	3B8A12F0858F9DF4459F	+85262645180	发布公告 今天全场打折8折	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:46:19	2026-04-18 07:46:19	2026-04-18 07:46:19
182	main	inbound	whatsapp	default	+85262645180	3B82F688BE5FB3E3B20D	+85262645180	我的店铺的地址是？	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:46:42	2026-04-18 07:46:42	2026-04-18 07:46:42
183	main	inbound	whatsapp	default	+85262645180	3B0E47074D940B1D4014	+85262645180	好	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:46:55	2026-04-18 07:46:55	2026-04-18 07:46:55
184	main	inbound	whatsapp	default	+85262645180	3B9000E8FFCD22E1E643	+85262645180	如何更新店铺	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:47:11	2026-04-18 07:47:11	2026-04-18 07:47:11
185	main	inbound	whatsapp	default	+85262645180	3B764BCDABD06E354C19	+85262645180	好的	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:47:35	2026-04-18 07:47:35	2026-04-18 07:47:35
186	main	inbound	whatsapp	default	+85262645180	3B5BF03034760DDFD483	+85262645180	现在有什么商品	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:47:52	2026-04-18 07:47:52	2026-04-18 07:47:52
187	main	inbound	whatsapp	default	+85262645180	3BE61467B2780BB831F3	+85262645180	好啊	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:48:04	2026-04-18 07:48:04	2026-04-18 07:48:04
188	main	inbound	whatsapp	default	+85262645180	3B3502CED55B0C5FAE7D	+85262645180	苹果 5元一斤	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:48:18	2026-04-18 07:48:18	2026-04-18 07:48:18
189	main	inbound	whatsapp	default	+85262645180	3B3C9BFC7679AA658AB3	+85262645180	100斤	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:48:29	2026-04-18 07:48:29	2026-04-18 07:48:29
190	main	inbound	whatsapp	default	+85262645180	3B5AB7B1CF454A065B47	+85262645180	我看看效果	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:48:46	2026-04-18 07:48:46	2026-04-18 07:48:46
191	main	inbound	whatsapp	default	+85262645180	3B34C924DB5AC3E5EB86	+85262645180	给我店铺的二维码	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-17 23:48:57	2026-04-18 07:48:57	2026-04-18 07:48:57
192	main	inbound	whatsapp	default	+85262645180	ACE0A206B1D63C539964134562DF9672	+85262645180	/new	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:00:39	2026-04-18 11:00:39	2026-04-18 11:00:39
193	main	inbound	whatsapp	default	+85262645180	ACD1E78A554770A6D0A9825D2833B5BB	+85262645180	删除clawmart 这个skill	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:01:21	2026-04-18 11:01:21	2026-04-18 11:01:21
194	main	inbound	whatsapp	default	+85262645180	ACFBA3C7C488EAAA2F39C856CAE45446	+85262645180	安装skill \nhttps://github.com/xingke2023/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:03:11	2026-04-18 11:03:11	2026-04-18 11:03:11
195	main	inbound	whatsapp	default	+85262645180	AC4BC54910EEAA853292D84991409A21	+85262645180	生效了吗 这个skill	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:03:48	2026-04-18 11:03:48	2026-04-18 11:03:48
196	main	inbound	whatsapp	default	+85262645180	ACB432672C4ADCA739FBAC04A8297A8A	+85262645180	/clawmart	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:04:18	2026-04-18 11:04:18	2026-04-18 11:04:18
197	main	inbound	whatsapp	default	+85262645180	AC54D2CB4ABE8CE9B7398B9DCA0FF737	+85262645180	注册	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:04:40	2026-04-18 11:04:40	2026-04-18 11:04:40
198	main	inbound	whatsapp	default	+85262645180	AC4C13431A6C470D5FA73BA467E6F67A	+85262645180	rose	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:04:58	2026-04-18 11:04:58	2026-04-18 11:04:58
199	main	inbound	whatsapp	default	+85262645180	AC63563D32D49F541AA0BD672877B2FD	+85262645180	uuuu8888	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:05:16	2026-04-18 11:05:16	2026-04-18 11:05:16
200	main	inbound	whatsapp	default	+85262645180	ACA050602EF3A531F1356CD5451F81A0	+85262645180	店铺叫 汉庭深圳湾口岸店	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:05:50	2026-04-18 11:05:50	2026-04-18 11:05:50
201	main	inbound	whatsapp	default	+85262645180	AC1DDADAB665D0FBF5D0BF43BCC75D1F	+85262645180	这个店的电话是62645180 地址是深圳湾口岸东滨路十八号	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:06:32	2026-04-18 11:06:33	2026-04-18 11:06:33
202	main	inbound	whatsapp	default	+85262645180	AC7567675D8C71DFCE25FC23D737BA80	+85262645180	这个店的房间有25间 有15间大床房 10间双床房 价格基本是从300到500不等	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:07:17	2026-04-18 11:07:17	2026-04-18 11:07:17
203	main	inbound	whatsapp	default	+85262645180	AC51B1AA3568353AC13EFCB1912C48F1	+85262645180	给我做一个店铺的宣传海报	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:07:46	2026-04-18 11:07:46	2026-04-18 11:07:46
204	main	inbound	whatsapp	default	+85262645180	ACF23C5A1F1D9A1238EE2641E9270164	+85262645180	<media:image>	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:08:13	2026-04-18 11:08:13	2026-04-18 11:08:13
205	main	inbound	whatsapp	default	+85262645180	ACDE20A050143249852F61326BC600B7	+85262645180	这里可以免费停车 免费洗衣服 会员送早餐	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:08:47	2026-04-18 11:08:47	2026-04-18 11:08:47
206	main	outbound	whatsapp	default	+85262645180	3EB0306487053721BD751A	\N	好的，我来更新店铺描述，把这些福利加进去！	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:09:34	2026-04-18 11:09:34	2026-04-18 11:09:34
207	main	outbound	whatsapp	default	+85262645180	3EB0C43D5B5C7806E89722	\N	✅ 店铺信息已更新！\n\n- 📝 简介：已加入免费停车、免费洗衣、会员送早餐\n- 🏷 标签：免费停车 / 免费洗衣 / 会员送早餐 / 深圳湾口岸 / 商务出行\n\n还有什么要补充的吗？	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:09:34	2026-04-18 11:09:34	2026-04-18 11:09:34
208	main	inbound	whatsapp	default	+85262645180	AC5D0BF440F3EC887DEAE391A8D32110	+85262645180	好的	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:09:42	2026-04-18 11:09:42	2026-04-18 11:09:42
209	main	inbound	whatsapp	default	+85262645180	AC6A08FB8A2FFC731469BCF97CC29F30	+85262645180	就是这两天的销量不是很好 这个要跟店长他们要反馈一下 看看是怎么回事 开个会	t	\N	agent:main:whatsapp:direct:+85262645180	2026-04-18 03:10:05	2026-04-18 11:10:05	2026-04-18 11:10:05
\.


--
-- Data for Name: competitor_hot_products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.competitor_hot_products (id, competitor_id, competitor_product_id, identified_date, heat_score, evidence, our_product_id, recommendation, reviewed_by, reviewed_at, created_at) FROM stdin;
\.


--
-- Data for Name: competitor_price_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.competitor_price_records (id, competitor_product_id, competitor_id, product_id, price, original_price, is_promotion, collect_source, collect_channel, image_url, collected_by, collected_at, created_at) FROM stdin;
\.


--
-- Data for Name: competitor_products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.competitor_products (id, competitor_id, product_id, competitor_product_name, competitor_product_code, spec, match_confidence, is_manually_confirmed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: competitors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.competitors (id, organization_id, name, brand, address, latitude, longitude, distance_to_store, nearest_store_id, channels, status, notes, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: custom_report_templates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_report_templates (id, organization_id, created_by, name, description, data_sources, filters, columns, chart_types, schedule_cron, is_shared, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_follow_ups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_follow_ups (id, customer_id, store_id, type, content, follow_up_at, next_follow_up_at, operator_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customer_order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_order_items (id, customer_order_id, product_id, product_name, qty, unit, unit_price, subtotal, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customer_orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_orders (id, store_id, order_no, customer_id, customer_name, customer_phone, type, status, total_amount, discount_amount, paid_amount, payment_method, delivery_address, delivery_at, remark, operator_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customers (id, store_id, name, phone, gender, birthday, level, points, total_spent, order_count, last_order_at, tags, address, source, status, notes, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: daily_operation_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_operation_logs (id, store_id, date, occurred_at, source, content, intent, is_operational, product_id, qty_change, reference_type, reference_id, operator_id, created_at, updated_at, is_failed, http_status_code, error_message) FROM stdin;
1	1	2026-03-31	2026-03-31 04:22:14	1	AI助手: 今天下午到货了50斤苹果，请帮我录入库存	other	f	\N	\N	ai_message	3	8	2026-03-31 04:22:14	2026-03-31 04:22:14	f	\N	\N
2	1	2026-03-31	2026-03-31 04:22:18	1	AI助手: 今天下午有50斤苹果到货了	other	f	\N	\N	ai_message	5	8	2026-03-31 04:22:18	2026-03-31 04:22:18	f	\N	\N
3	1	2026-03-31	2026-03-31 04:22:38	1	AI助手: 今天下午有50斤苹果到货了	other	f	\N	\N	ai_message	7	8	2026-03-31 04:22:38	2026-03-31 04:22:38	f	\N	\N
4	1	2026-03-31	2026-03-31 04:23:28	1	AI助手: 今天下午有50斤苹果到货了	purchase_receipt	t	\N	\N	inventory	8	8	2026-03-31 04:23:28	2026-03-31 04:23:28	f	\N	\N
5	1	2026-03-31	2026-03-31 04:43:14	1	AI助手: 猪五花肉卖掉10斤	other	f	\N	\N	ai_message	9	8	2026-03-31 04:43:14	2026-03-31 04:43:14	f	\N	\N
6	1	2026-03-31	2026-03-31 05:21:29	2	手动调整: 测试售罄	sold_out	t	8	-50.000	inventory	8	8	2026-03-31 05:21:29	2026-03-31 05:21:29	f	\N	\N
7	1	2026-03-31	2026-03-31 05:21:29	2	补录销售: 测试补录	supplement	t	8	-5.000	sales_order	2	8	2026-03-31 05:21:29	2026-03-31 05:21:29	f	\N	\N
8	1	2026-03-31	2026-03-31 05:22:10	2	手动调整: 盘点修正测试	adjust	t	1	5.900	inventory	1	8	2026-03-31 05:22:10	2026-03-31 05:22:10	f	\N	\N
9	1	2026-03-31	2026-03-31 05:22:10	2	手动调整: 腐烂损耗	damage	t	3	-5.000	inventory	3	8	2026-03-31 05:22:10	2026-03-31 05:22:10	f	\N	\N
10	1	2026-03-31	2026-03-31 05:22:10	1	AI助手: 今天苹果到货50斤	other	f	\N	\N	ai_message	11	8	2026-03-31 05:22:10	2026-03-31 05:22:10	f	\N	\N
11	1	2026-03-31	2026-03-31 05:27:01	2	手动调整: 腐烂测试	damage	t	3	-2.000	inventory	3	8	2026-03-31 05:27:01	2026-03-31 05:27:01	f	\N	\N
12	1	2026-03-31	2026-03-31 05:27:01	2	手动调整: 售罄测试	sold_out	t	4	-65.300	inventory	4	8	2026-03-31 05:27:01	2026-03-31 05:27:01	f	\N	\N
13	1	2026-03-31	2026-03-31 05:27:34	1	AI助手: 卖了5斤番茄	other	f	\N	\N	ai_message	13	8	2026-03-31 05:27:34	2026-03-31 05:27:34	f	\N	\N
14	1	2026-03-31	2026-03-31 05:43:45	1	AI助手: 苹果卖完了	other	f	\N	\N	ai_message	15	8	2026-03-31 05:43:45	2026-03-31 05:43:45	f	\N	\N
15	2	2026-03-31	2026-03-31 06:44:27	2	进货收货: PO-20260331-00001 共 2 个SKU	stock_in	t	\N	\N	purchase_order	16	9	2026-03-31 06:44:27	2026-03-31 06:44:27	f	\N	\N
16	2	2026-03-31	2026-03-31 06:49:33	2	进货收货: PO-20260331-00002 共 1 个SKU	stock_in	t	\N	\N	purchase_order	17	9	2026-03-31 06:49:33	2026-03-31 06:49:33	f	\N	\N
17	2	2026-03-31	2026-03-31 08:49:04	1	AI助手: 现在，番茄卖得很慢	other	f	\N	\N	ai_message	17	9	2026-03-31 08:49:04	2026-03-31 08:49:04	f	\N	\N
18	2	2026-04-01	2026-04-01 04:49:29	2	进货收货: PO-20260401-00001 共 8 个SKU	stock_in	t	\N	\N	purchase_order	18	9	2026-04-01 04:49:29	2026-04-01 04:49:29	f	\N	\N
19	2	2026-04-01	2026-04-01 04:56:43	2	进货收货: PO-20260401-00002 共 16 个SKU	stock_in	t	\N	\N	purchase_order	19	9	2026-04-01 04:56:43	2026-04-01 04:56:43	f	\N	\N
20	2	2026-04-01	2026-04-01 05:24:19	2	手动调整: 清空库存	adjust	t	46	-60.000	inventory	46	9	2026-04-01 05:24:19	2026-04-01 05:24:19	f	\N	\N
21	2	2026-04-01	2026-04-01 05:24:19	2	手动调整: 清空库存	adjust	t	32	-72.000	inventory	32	9	2026-04-01 05:24:19	2026-04-01 05:24:19	f	\N	\N
22	2	2026-04-01	2026-04-01 05:24:19	2	手动调整: 清空库存	adjust	t	33	-38.000	inventory	33	9	2026-04-01 05:24:19	2026-04-01 05:24:19	f	\N	\N
23	2	2026-04-01	2026-04-01 05:24:19	2	手动调整: 清空库存	adjust	t	34	-120.000	inventory	34	9	2026-04-01 05:24:19	2026-04-01 05:24:19	f	\N	\N
24	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	35	-19.000	inventory	35	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
25	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	36	-64.000	inventory	36	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
26	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	37	-36.000	inventory	37	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
27	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	38	-48.000	inventory	38	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
28	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	39	-12.000	inventory	39	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
29	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	9	-85.300	inventory	9	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
30	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	40	-20.000	inventory	40	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
31	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	41	-10.000	inventory	41	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
32	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	42	-96.000	inventory	42	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
33	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	43	-50.000	inventory	43	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
34	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	44	-18.000	inventory	44	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
35	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	45	-20.000	inventory	45	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
36	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	24	-1.000	inventory	24	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
37	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	31	-1.000	inventory	31	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
38	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	30	-1.000	inventory	30	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
39	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	29	-1.000	inventory	29	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
40	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	28	-1.000	inventory	28	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
41	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	27	-1.000	inventory	27	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
42	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	26	-1.000	inventory	26	9	2026-04-01 05:24:20	2026-04-01 05:24:20	f	\N	\N
43	2	2026-04-01	2026-04-01 05:24:20	2	手动调整: 清空库存	adjust	t	25	-1.000	inventory	25	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
44	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	10	-74.200	inventory	10	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
45	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	23	-20.000	inventory	23	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
46	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	22	-30.000	inventory	22	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
47	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	7	-87.300	inventory	7	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
48	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	6	-200.600	inventory	6	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
49	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	11	-54.700	inventory	11	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
50	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	12	-54.200	inventory	12	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
51	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	15	-38.100	inventory	15	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
52	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	4	-131.400	inventory	4	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
53	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	18	-91.500	inventory	18	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
54	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	3	-253.000	inventory	3	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
55	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	1	-169.000	inventory	1	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
56	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	17	-33.400	inventory	17	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
57	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	14	-23.500	inventory	14	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
58	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	19	-47.500	inventory	19	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
59	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	5	-38.000	inventory	5	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
60	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	2	-42.000	inventory	2	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
61	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	8	-55.000	inventory	8	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
62	2	2026-04-01	2026-04-01 05:24:21	2	手动调整: 清空库存	adjust	t	13	-10.000	inventory	13	9	2026-04-01 05:24:21	2026-04-01 05:24:21	f	\N	\N
63	2	2026-04-01	2026-04-01 05:24:22	2	手动调整: 清空库存	adjust	t	16	-8.000	inventory	16	9	2026-04-01 05:24:22	2026-04-01 05:24:22	f	\N	\N
64	2	2026-04-01	2026-04-01 05:24:22	2	手动调整: 清空库存	adjust	t	20	-200.000	inventory	20	9	2026-04-01 05:24:22	2026-04-01 05:24:22	f	\N	\N
65	2	2026-04-01	2026-04-01 05:24:22	2	手动调整: 清空库存	adjust	t	21	-12.000	inventory	21	9	2026-04-01 05:24:22	2026-04-01 05:24:22	f	\N	\N
66	2	2026-04-01	2026-04-01 07:38:14	1	AI助手: [图片输入]	other	f	\N	\N	ai_message	19	9	2026-04-01 07:38:14	2026-04-01 07:38:14	f	\N	\N
67	2	2026-04-01	2026-04-01 07:40:36	2	手动调整: probe	adjust	t	1	0.000	inventory	1	9	2026-04-01 07:40:36	2026-04-01 07:40:36	f	\N	\N
68	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	2	0.000	inventory	2	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
69	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	3	0.000	inventory	3	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
70	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	4	0.000	inventory	4	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
71	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	5	0.000	inventory	5	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
72	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	6	0.000	inventory	6	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
73	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	7	0.000	inventory	7	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
74	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	8	0.000	inventory	8	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
75	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	9	0.000	inventory	9	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
76	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	10	0.000	inventory	10	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
77	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	11	0.000	inventory	11	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
78	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	12	0.000	inventory	12	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
79	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	13	0.000	inventory	13	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
80	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	14	0.000	inventory	14	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
81	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	15	0.000	inventory	15	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
82	2	2026-04-01	2026-04-01 07:40:37	2	手动调整: probe	adjust	t	16	0.000	inventory	16	9	2026-04-01 07:40:37	2026-04-01 07:40:37	f	\N	\N
83	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	17	0.000	inventory	17	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
84	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	18	0.000	inventory	18	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
85	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	19	0.000	inventory	19	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
86	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	20	0.000	inventory	20	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
87	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	21	0.000	inventory	21	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
88	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	22	0.000	inventory	22	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
89	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	23	0.000	inventory	23	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
90	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	24	0.000	inventory	24	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
91	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	25	0.000	inventory	25	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
92	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	26	0.000	inventory	26	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
93	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	27	0.000	inventory	27	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
94	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	28	0.000	inventory	28	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
95	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	29	0.000	inventory	29	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
96	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	30	0.000	inventory	30	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
97	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	31	0.000	inventory	31	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
98	2	2026-04-01	2026-04-01 07:40:38	2	手动调整: probe	adjust	t	32	0.000	inventory	32	9	2026-04-01 07:40:38	2026-04-01 07:40:38	f	\N	\N
99	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	33	0.000	inventory	33	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
100	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	34	0.000	inventory	34	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
101	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	35	0.000	inventory	35	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
102	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	36	0.000	inventory	36	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
103	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	37	0.000	inventory	37	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
104	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	38	0.000	inventory	38	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
105	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	39	0.000	inventory	39	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
106	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	40	0.000	inventory	40	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
107	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	41	0.000	inventory	41	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
108	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	42	0.000	inventory	42	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
109	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	43	0.000	inventory	43	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
110	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	44	0.000	inventory	44	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
111	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	45	0.000	inventory	45	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
112	2	2026-04-01	2026-04-01 07:40:39	2	手动调整: probe	adjust	t	46	0.000	inventory	46	9	2026-04-01 07:40:39	2026-04-01 07:40:39	f	\N	\N
113	2	2026-04-01	2026-04-01 07:40:47	2	手动调整: probe	adjust	t	1	0.000	inventory	1	9	2026-04-01 07:40:47	2026-04-01 07:40:47	f	\N	\N
114	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	1	0.000	inventory	1	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
115	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	2	0.000	inventory	2	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
116	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	3	0.000	inventory	3	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
117	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	4	0.000	inventory	4	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
118	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	5	0.000	inventory	5	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
119	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	6	0.000	inventory	6	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
120	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	7	0.000	inventory	7	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
121	2	2026-04-01	2026-04-01 07:40:54	2	手动调整: probe	adjust	t	8	0.000	inventory	8	9	2026-04-01 07:40:54	2026-04-01 07:40:54	f	\N	\N
122	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	9	0.000	inventory	9	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
123	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	10	0.000	inventory	10	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
124	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	11	0.000	inventory	11	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
125	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	12	0.000	inventory	12	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
126	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	13	0.000	inventory	13	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
127	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	14	0.000	inventory	14	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
128	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	15	0.000	inventory	15	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
129	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	16	0.000	inventory	16	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
130	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	17	0.000	inventory	17	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
131	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	18	0.000	inventory	18	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
132	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	19	0.000	inventory	19	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
133	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	20	0.000	inventory	20	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
134	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	21	0.000	inventory	21	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
135	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	22	0.000	inventory	22	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
136	2	2026-04-01	2026-04-01 07:40:55	2	手动调整: probe	adjust	t	23	0.000	inventory	23	9	2026-04-01 07:40:55	2026-04-01 07:40:55	f	\N	\N
137	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	24	0.000	inventory	24	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
138	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	25	0.000	inventory	25	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
139	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	26	0.000	inventory	26	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
140	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	27	0.000	inventory	27	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
141	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	28	0.000	inventory	28	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
142	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	29	0.000	inventory	29	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
143	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	30	0.000	inventory	30	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
144	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	31	0.000	inventory	31	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
145	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	32	0.000	inventory	32	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
146	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	33	0.000	inventory	33	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
147	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	34	0.000	inventory	34	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
148	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	35	0.000	inventory	35	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
149	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	36	0.000	inventory	36	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
150	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	37	0.000	inventory	37	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
151	2	2026-04-01	2026-04-01 07:40:56	2	手动调整: probe	adjust	t	38	0.000	inventory	38	9	2026-04-01 07:40:56	2026-04-01 07:40:56	f	\N	\N
152	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	39	0.000	inventory	39	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
153	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	40	0.000	inventory	40	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
154	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	41	0.000	inventory	41	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
155	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	42	0.000	inventory	42	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
156	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	43	0.000	inventory	43	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
157	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	44	0.000	inventory	44	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
158	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	45	0.000	inventory	45	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
159	2	2026-04-01	2026-04-01 07:40:57	2	手动调整: probe	adjust	t	46	0.000	inventory	46	9	2026-04-01 07:40:57	2026-04-01 07:40:57	f	\N	\N
160	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	24	6.000	inventory	24	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
161	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	25	6.000	inventory	25	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
162	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	26	6.000	inventory	26	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
163	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	27	6.000	inventory	27	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
164	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	28	6.000	inventory	28	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
165	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	29	6.000	inventory	29	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
166	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	30	6.000	inventory	30	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
167	2	2026-04-01	2026-04-01 07:41:09	2	手动调整: 四海环球进货 发票2603-10454 进货日2026-03-21 每袋6包	adjust	t	31	6.000	inventory	31	9	2026-04-01 07:41:09	2026-04-01 07:41:09	f	\N	\N
168	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	34	2.000	inventory	34	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
169	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	35	1.000	inventory	35	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
170	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	36	1.000	inventory	36	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
171	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	37	2.000	inventory	37	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
172	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	32	1.000	inventory	32	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
173	2	2026-04-01	2026-04-01 08:05:22	2	手动调整: 水果进货 2026-03-24	adjust	t	33	1.000	inventory	33	9	2026-04-01 08:05:22	2026-04-01 08:05:22	f	\N	\N
174	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	38	2.000	inventory	38	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
175	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	39	2.000	inventory	39	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
176	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	9	1.000	inventory	9	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
177	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	41	0.500	inventory	41	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
178	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	40	1.000	inventory	40	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
179	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	43	1.000	inventory	43	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
180	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	42	1.000	inventory	42	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
181	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	45	2.000	inventory	45	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
182	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	44	1.000	inventory	44	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
183	2	2026-04-01	2026-04-01 08:05:23	2	手动调整: 水果进货 2026-03-24	adjust	t	46	5.000	inventory	46	9	2026-04-01 08:05:23	2026-04-01 08:05:23	f	\N	\N
184	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	34	0.000	inventory	34	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
185	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	35	0.000	inventory	35	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
186	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	36	0.000	inventory	36	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
187	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	37	0.000	inventory	37	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
188	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	32	0.000	inventory	32	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
189	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	33	0.000	inventory	33	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
190	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	38	0.000	inventory	38	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
191	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	39	0.000	inventory	39	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
192	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	9	0.000	inventory	9	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
193	2	2026-04-01	2026-04-01 08:29:27	2	手动调整: 水果进货 2026-04-01	adjust	t	41	0.000	inventory	41	9	2026-04-01 08:29:27	2026-04-01 08:29:27	f	\N	\N
194	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	40	0.000	inventory	40	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
195	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	43	0.000	inventory	43	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
196	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	42	0.000	inventory	42	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
197	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	45	0.000	inventory	45	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
198	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	44	0.000	inventory	44	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
199	2	2026-04-01	2026-04-01 08:29:28	2	手动调整: 水果进货 2026-04-01	adjust	t	46	0.000	inventory	46	9	2026-04-01 08:29:28	2026-04-01 08:29:28	f	\N	\N
200	2	2026-04-01	2026-04-01 08:41:59	1	AI助手: 今天到货：野生苹果1件、小台芒1件、耙耙柑2件、香蕉1件、牛奶蕉1件、赣南脐橙1件、散装枇杷2件、精品草莓2件、袋装金桔2件、油柑1件、小青橘0.5件、带叶沃柑1件、菠萝1件、大木瓜1件	other	f	\N	\N	ai_message	21	9	2026-04-01 08:41:59	2026-04-01 08:41:59	f	\N	\N
201	2	2026-04-01	2026-04-01 08:46:12	2	进货收货: PO-20260401-00001 共 14 个SKU	stock_in	t	\N	\N	purchase_order	41	9	2026-04-01 08:46:12	2026-04-01 08:46:12	f	\N	\N
202	2	2026-04-01	2026-04-01 08:47:55	2	进货收货: PO-20260401-00002 共 8 个SKU	stock_in	t	\N	\N	purchase_order	42	9	2026-04-01 08:47:55	2026-04-01 08:47:55	f	\N	\N
203	2	2026-04-04	2026-04-04 02:44:34	2	售罄补录: 番茄 剩余 0斤 已售罄	sold_out	t	4	0.000	sales_order	\N	1	2026-04-04 02:44:34	2026-04-04 02:44:34	f	\N	\N
204	2	2026-04-04	2026-04-04 02:44:34	2	售罄补录: 胡萝卜 剩余 0斤 已售罄	sold_out	t	1	0.000	sales_order	\N	1	2026-04-04 02:44:34	2026-04-04 02:44:34	f	\N	\N
205	2	2026-04-04	2026-04-04 02:44:59	2	售罄补录: 番茄 剩余 30斤 已售罄，清空时间 02:44	sold_out	t	4	-30.000	sales_order	\N	1	2026-04-04 02:44:59	2026-04-04 02:44:59	f	\N	\N
206	2	2026-04-04	2026-04-04 02:44:59	2	售罄补录: 胡萝卜 剩余 20斤 已售罄	sold_out	t	1	-15.000	sales_order	\N	1	2026-04-04 02:44:59	2026-04-04 02:44:59	f	\N	\N
207	2	2026-04-04	2026-04-04 02:45:37	2	售罄补录: 番茄 全部 30斤 已售罄，清空时间 02:44	sold_out	t	4	-30.000	sales_order	\N	1	2026-04-04 02:45:37	2026-04-04 02:45:37	f	\N	\N
208	2	2026-04-04	2026-04-04 02:45:37	2	库存补录: 胡萝卜 售出 15斤，剩余 5斤	supplement	t	1	-15.000	sales_order	\N	1	2026-04-04 02:45:37	2026-04-04 02:45:37	f	\N	\N
209	2	2026-04-04	2026-04-04 02:47:00	2	售罄: 番茄 全部 30斤 已售罄，清空时间 02:44	sold_out	t	4	-30.000	sales_order	\N	1	2026-04-04 02:47:00	2026-04-04 02:47:00	f	\N	\N
210	2	2026-04-04	2026-04-04 02:47:00	2	库存补录: 胡萝卜 售出 25斤，剩余 5斤	supplement	t	1	-25.000	sales_order	\N	1	2026-04-04 02:47:00	2026-04-04 02:47:00	f	\N	\N
211	2	2026-04-04	2026-04-04 02:47:00	2	销售补录: 白菜 售出 10斤，剩余 0斤	supplement	t	3	-10.000	sales_order	\N	1	2026-04-04 02:47:00	2026-04-04 02:47:00	f	\N	\N
212	3	2026-04-04	2026-04-04 07:24:08	2	销售补录: 胡萝卜 售出 10斤，剩余 144.1斤	supplement	t	1	-10.000	sales_order	\N	11	2026-04-04 07:24:08	2026-04-04 07:24:08	f	\N	\N
213	3	2026-04-04	2026-04-04 07:25:26	2	售罄: 洋葱 全部 66.6斤 已售罄，清空时间 07:25	sold_out	t	7	-66.600	sales_order	\N	11	2026-04-04 07:25:26	2026-04-04 07:25:26	f	\N	\N
214	3	2026-04-04	2026-04-04 08:09:48	2	进货收货: PO-20260404-00001 共 8 个SKU	stock_in	t	\N	\N	purchase_order	43	11	2026-04-04 08:09:48	2026-04-04 08:09:48	f	\N	\N
215	3	2026-04-07	2026-04-07 01:10:59	2	进货收货: PO-20260407-00001 共 10 个SKU	stock_in	t	\N	\N	purchase_order	44	11	2026-04-07 01:10:59	2026-04-07 01:10:59	f	\N	\N
216	3	2026-04-07	2026-04-07 06:50:00	2	售罄: 小木瓜 全部 72斤 已售罄，清空时间 06:50	sold_out	t	59	-72.000	sales_order	\N	11	2026-04-07 06:50:56	2026-04-07 06:50:56	f	\N	\N
217	2	2026-04-15	2026-04-15 21:49:05	2	[失败 422] POST /api/inventory/adjust	error	f	\N	\N	\N	\N	1	2026-04-15 21:49:05	2026-04-15 21:49:05	t	422	The product id field is required. (and 1 more error)
218	1	2026-04-16	2026-04-16 12:17:46	2	进货收货: PO-20260416-00001 共 6 个SKU	stock_in	t	\N	\N	purchase_order	45	10	2026-04-16 12:17:46	2026-04-16 12:17:46	f	\N	\N
219	1	2026-04-16	2026-04-16 16:00:00	2	售罄: 胡萝卜 全部 100斤 已售罄，清空时间 16:00	sold_out	t	1	-100.000	sales_order	\N	5	2026-04-16 22:44:01	2026-04-16 22:44:01	f	\N	\N
220	3	2026-04-16	2026-04-16 23:14:36	2	售罄: 白菜 全部 223.9斤 已售罄，清空时间 23:14	sold_out	t	3	-223.900	sales_order	\N	11	2026-04-16 23:14:36	2026-04-16 23:14:36	f	\N	\N
221	3	2026-04-16	2026-04-16 23:19:24	2	库存补录: 胡萝卜 售出 134.1斤，剩余 10斤	supplement	t	1	-134.100	sales_order	\N	11	2026-04-16 23:19:24	2026-04-16 23:19:24	f	\N	\N
222	3	2026-04-16	2026-04-16 23:32:59	2	手动调整: 白菜损耗	damage	t	3	-10.000	inventory	3	11	2026-04-16 23:32:59	2026-04-16 23:32:59	f	\N	\N
223	3	2026-04-17	2026-04-17 00:04:51	2	[失败 500] GET /api/weather	error	f	\N	\N	\N	\N	8	2026-04-17 00:04:51	2026-04-17 00:04:51	t	500	天气查询失败，请稍后重试
224	2	2026-04-26	2026-04-26 18:22:10	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	1	2026-04-26 18:22:10	2026-04-26 18:22:10	t	422	HTTP 422
225	2	2026-04-26	2026-04-26 18:30:32	1	AI助手: 你好	other	f	\N	\N	ai_message	23	1	2026-04-26 18:30:32	2026-04-26 18:30:32	f	\N	\N
226	2	2026-04-26	2026-04-26 18:30:39	1	AI助手: 今天天气怎么样	other	f	\N	\N	ai_message	25	1	2026-04-26 18:30:39	2026-04-26 18:30:39	f	\N	\N
227	1	2026-04-26	2026-04-26 19:25:47	1	AI助手: 你好	other	f	\N	\N	ai_message	27	12	2026-04-26 19:25:47	2026-04-26 19:25:47	f	\N	\N
228	1	2026-04-26	2026-04-26 19:25:54	1	AI助手: 今天天气怎么样	weather_query	f	\N	\N	ai_message	29	12	2026-04-26 19:25:54	2026-04-26 19:25:54	f	\N	\N
229	1	2026-04-26	2026-04-26 19:26:03	1	AI助手: 今天进货多少	other	f	\N	\N	ai_message	31	12	2026-04-26 19:26:03	2026-04-26 19:26:03	f	\N	\N
230	1	2026-04-26	2026-04-26 19:26:16	1	AI助手: 今天进货情况是怎么样的	other	f	\N	\N	ai_message	33	12	2026-04-26 19:26:16	2026-04-26 19:26:16	f	\N	\N
231	1	2026-04-26	2026-04-26 19:31:33	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-04-26 19:31:33	2026-04-26 19:31:33	t	422	HTTP 422
232	1	2026-04-27	2026-04-27 20:04:32	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-04-27 20:04:32	2026-04-27 20:04:32	t	422	HTTP 422
233	1	2026-04-27	2026-04-27 20:58:36	1	AI助手: 胡萝卜卖了10斤	sale_report	t	1	0.000	ai_message	35	12	2026-04-27 20:58:36	2026-04-27 20:58:36	f	\N	\N
234	1	2026-04-27	2026-04-27 21:28:45	1	AI助手: 胡萝卜卖了10斤	sale_report	t	1	0.000	ai_message	37	12	2026-04-27 21:28:45	2026-04-27 21:28:45	f	\N	\N
235	2	2026-04-27	2026-04-27 21:56:48	1	AI助手: 番茄卖了10斤	sale_report	t	4	-10.000	ai_message	39	1	2026-04-27 21:56:48	2026-04-27 21:56:48	f	\N	\N
236	2	2026-04-27	2026-04-27 21:56:58	1	AI助手: 这是什么	other	f	\N	\N	ai_message	41	1	2026-04-27 21:56:58	2026-04-27 21:56:58	f	\N	\N
237	2	2026-04-27	2026-04-27 21:57:24	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	1	2026-04-27 21:57:24	2026-04-27 21:57:24	t	422	HTTP 422
238	2	2026-04-27	2026-04-27 21:57:51	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	1	2026-04-27 21:57:51	2026-04-27 21:57:51	t	422	HTTP 422
239	1	2026-04-27	2026-04-27 22:05:18	1	AI助手: 你現在在哪裡呀	other	f	\N	\N	ai_message	43	12	2026-04-27 22:05:18	2026-04-27 22:05:18	f	\N	\N
240	1	2026-04-27	2026-04-27 22:22:40	1	AI助手: 你好	other	f	\N	\N	ai_message	45	12	2026-04-27 22:22:40	2026-04-27 22:22:40	f	\N	\N
241	1	2026-04-27	2026-04-27 22:26:23	1	AI助手: 白菜 又卖了22.6斤	sale_report	t	3	-22.600	ai_message	47	12	2026-04-27 22:26:23	2026-04-27 22:26:23	f	\N	\N
242	1	2026-04-27	2026-04-27 22:58:49	1	AI助手: 你好 你在哪里	other	f	\N	\N	ai_message	49	12	2026-04-27 22:58:49	2026-04-27 22:58:49	f	\N	\N
243	1	2026-04-28	2026-04-28 12:46:23	2	进货收货: PO-20260428-00001 共 1 个SKU	stock_in	t	\N	\N	purchase_order	46	13	2026-04-28 12:46:23	2026-04-28 12:46:23	f	\N	\N
244	1	2026-04-28	2026-04-28 13:08:01	1	AI助手: 今日草莓半斤坏果	waste_report	t	38	0.000	ai_message	51	13	2026-04-28 13:08:01	2026-04-28 13:08:01	f	\N	\N
245	1	2026-04-28	2026-04-28 13:14:29	1	AI助手: 给我一个进货建议	other	f	\N	\N	ai_message	53	13	2026-04-28 13:14:29	2026-04-28 13:14:29	f	\N	\N
246	1	2026-04-28	2026-04-28 13:31:17	1	AI助手: 苹果还剩20斤，有什么建议？	remaining	t	8	20.000	ai_message	55	13	2026-04-28 13:31:17	2026-04-28 13:31:17	f	\N	\N
247	1	2026-04-29	2026-04-29 07:51:01	1	AI助手: 你好	other	f	\N	\N	ai_message	57	12	2026-04-29 07:51:01	2026-04-29 07:51:01	f	\N	\N
248	1	2026-04-29	2026-04-29 08:19:43	1	AI助手: 苹果卖完了	sold_out	t	8	-20.000	ai_message	59	12	2026-04-29 08:19:43	2026-04-29 08:19:43	f	\N	\N
249	1	2026-05-11	2026-05-11 05:30:37	1	AI助手: 上传进货单	purchase_receipt	t	4	50.000	ai_message	61	12	2026-05-11 05:30:37	2026-05-11 05:30:37	f	\N	\N
250	1	2026-05-11	2026-05-11 05:30:37	1	AI助手: 上传进货单	purchase_receipt	t	1	30.000	ai_message	61	12	2026-05-11 05:30:37	2026-05-11 05:30:37	f	\N	\N
251	1	2026-05-11	2026-05-11 05:31:00	1	AI助手: 上传了什么	other	f	\N	\N	ai_message	63	12	2026-05-11 05:31:00	2026-05-11 05:31:00	f	\N	\N
252	1	2026-05-11	2026-05-11 05:31:16	2	[失败 500] POST /api/ai/message	error	f	\N	\N	\N	\N	12	2026-05-11 05:31:16	2026-05-11 05:31:16	t	500	App\\Services\\AiService::parseInventoryIntent(): Argument #1 ($text) must be of type string, null given, called in /home/ubuntu/shejian-hk/backend/app/Http/Controllers/Api/AiAssistantController.php on line 59
253	1	2026-05-11	2026-05-11 05:34:08	1	AI助手: 你現在在哪裡呀	other	f	\N	\N	ai_message	65	12	2026-05-11 05:34:08	2026-05-11 05:34:08	f	\N	\N
254	1	2026-05-11	2026-05-11 05:34:46	2	[失败 500] POST /api/ai/message	error	f	\N	\N	\N	\N	12	2026-05-11 05:34:46	2026-05-11 05:34:46	t	500	App\\Services\\AiService::parseInventoryIntent(): Argument #1 ($text) must be of type string, null given, called in /home/ubuntu/shejian-hk/backend/app/Http/Controllers/Api/AiAssistantController.php on line 59
255	1	2026-05-11	2026-05-11 05:36:12	1	AI助手: [图片输入]	purchase_receipt	t	4	50.000	ai_message	67	12	2026-05-11 05:36:12	2026-05-11 05:36:12	f	\N	\N
256	1	2026-05-11	2026-05-11 05:36:12	1	AI助手: [图片输入]	purchase_receipt	t	1	30.000	ai_message	67	12	2026-05-11 05:36:12	2026-05-11 05:36:12	f	\N	\N
257	1	2026-05-11	2026-05-11 05:39:56	1	AI助手: 天气怎么样	weather_query	f	\N	\N	ai_message	69	12	2026-05-11 05:39:56	2026-05-11 05:39:56	f	\N	\N
258	1	2026-05-11	2026-05-11 05:41:39	1	AI助手: [图片输入]	purchase_receipt	t	4	50.000	ai_message	71	12	2026-05-11 05:41:39	2026-05-11 05:41:39	f	\N	\N
259	1	2026-05-11	2026-05-11 05:41:39	1	AI助手: [图片输入]	purchase_receipt	t	1	30.000	ai_message	71	12	2026-05-11 05:41:39	2026-05-11 05:41:39	f	\N	\N
260	1	2026-05-11	2026-05-11 05:50:16	1	AI助手: 今日进了什么火	purchase_orders_query	f	\N	\N	ai_message	73	12	2026-05-11 05:50:16	2026-05-11 05:50:16	f	\N	\N
261	1	2026-05-11	2026-05-11 05:50:56	1	AI助手: 今天的进货单可以看看吗	purchase_orders_query	f	\N	\N	ai_message	75	12	2026-05-11 05:50:56	2026-05-11 05:50:56	f	\N	\N
262	1	2026-05-11	2026-05-11 05:55:24	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	77	12	2026-05-11 05:55:24	2026-05-11 05:55:24	f	\N	\N
263	1	2026-05-11	2026-05-11 07:21:55	1	AI助手: 进了10斤橙子	purchase_receipt	t	10	10.000	ai_message	79	12	2026-05-11 07:21:55	2026-05-11 07:21:55	f	\N	\N
264	1	2026-05-11	2026-05-11 07:24:17	1	AI助手: 有10斤白菜坏了	waste_report	t	3	-10.000	ai_message	81	12	2026-05-11 07:24:17	2026-05-11 07:24:17	f	\N	\N
265	1	2026-05-11	2026-05-11 07:53:50	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	83	12	2026-05-11 07:53:50	2026-05-11 07:53:50	f	\N	\N
266	1	2026-05-11	2026-05-11 19:51:10	1	AI助手: 苹果损耗1斤	waste_report	t	8	0.000	ai_message	85	12	2026-05-11 19:51:10	2026-05-11 19:51:10	f	\N	\N
267	1	2026-05-11	2026-05-11 19:51:22	1	AI助手: 苹果损耗一斤	waste_report	t	8	0.000	ai_message	87	12	2026-05-11 19:51:22	2026-05-11 19:51:22	f	\N	\N
268	1	2026-05-11	2026-05-11 20:00:58	1	AI助手: 今天到货10斤胡萝卜，30斤猕猴桃	purchase_receipt	t	1	10.000	ai_message	89	13	2026-05-11 20:00:58	2026-05-11 20:00:58	f	\N	\N
269	1	2026-05-11	2026-05-11 20:00:58	1	AI助手: 今天到货10斤胡萝卜，30斤猕猴桃	purchase_receipt	t	64	30.000	ai_message	89	13	2026-05-11 20:00:58	2026-05-11 20:00:58	f	\N	\N
270	1	2026-05-11	2026-05-11 20:01:53	1	AI助手: 到货香蕉有2斤烂的	waste_report	t	9	-2.000	ai_message	91	13	2026-05-11 20:01:53	2026-05-11 20:01:53	f	\N	\N
271	1	2026-05-11	2026-05-11 20:28:44	1	AI助手: 今天苹果3点就卖完了	sold_out	t	8	0.000	ai_message	93	12	2026-05-11 20:28:44	2026-05-11 20:28:44	f	\N	\N
272	1	2026-05-11	2026-05-11 20:29:08	1	AI助手: 今天橙子三点多就卖完了	sold_out	t	10	-30.900	ai_message	95	12	2026-05-11 20:29:08	2026-05-11 20:29:08	f	\N	\N
273	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	37	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
274	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	65	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
275	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	66	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
276	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	2	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
277	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	67	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
278	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	68	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
279	1	2026-05-11	2026-05-11 21:02:17	1	AI助手: 坏货记录	waste_report	t	69	0.000	ai_message	97	12	2026-05-11 21:02:17	2026-05-11 21:02:17	f	\N	\N
280	1	2026-05-11	2026-05-11 21:03:03	1	AI助手: 枇杷坏货	waste_report	t	37	0.000	ai_message	99	12	2026-05-11 21:03:03	2026-05-11 21:03:03	f	\N	\N
281	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	70	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
282	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	71	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
283	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	50	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
284	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	72	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
285	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	73	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
286	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	74	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
287	1	2026-05-11	2026-05-11 21:04:20	1	AI助手: 入库	purchase_receipt	t	75	2.000	ai_message	101	12	2026-05-11 21:04:20	2026-05-11 21:04:20	f	\N	\N
288	1	2026-05-11	2026-05-11 21:04:51	1	AI助手: 入库	purchase_receipt	t	76	1.000	ai_message	103	12	2026-05-11 21:04:51	2026-05-11 21:04:51	f	\N	\N
289	1	2026-05-11	2026-05-11 21:04:51	1	AI助手: 入库	purchase_receipt	t	77	1.000	ai_message	103	12	2026-05-11 21:04:51	2026-05-11 21:04:51	f	\N	\N
290	1	2026-05-11	2026-05-11 21:04:51	1	AI助手: 入库	purchase_receipt	t	37	1.000	ai_message	103	12	2026-05-11 21:04:51	2026-05-11 21:04:51	f	\N	\N
291	1	2026-05-11	2026-05-11 21:04:51	1	AI助手: 入库	purchase_receipt	t	78	3.000	ai_message	103	12	2026-05-11 21:04:51	2026-05-11 21:04:51	f	\N	\N
292	1	2026-05-11	2026-05-11 21:04:51	1	AI助手: 入库	purchase_receipt	t	79	2.000	ai_message	103	12	2026-05-11 21:04:51	2026-05-11 21:04:51	f	\N	\N
293	1	2026-05-11	2026-05-11 21:08:30	1	AI助手: 本周四至周六有雨，请提前提醒下单减量	weather_query	f	\N	\N	ai_message	105	12	2026-05-11 21:08:30	2026-05-11 21:08:30	f	\N	\N
294	1	2026-05-11	2026-05-11 21:26:18	1	AI助手: 有什么应季的水果吗	suggestions_query	f	\N	\N	ai_message	107	12	2026-05-11 21:26:18	2026-05-11 21:26:18	f	\N	\N
295	2	2026-05-11	2026-05-11 21:35:31	1	AI助手: 进货单	purchase_receipt	t	80	6.000	ai_message	109	1	2026-05-11 21:35:31	2026-05-11 21:35:31	f	\N	\N
296	2	2026-05-11	2026-05-11 21:35:31	1	AI助手: 进货单	purchase_receipt	t	81	5.000	ai_message	109	1	2026-05-11 21:35:31	2026-05-11 21:35:31	f	\N	\N
297	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	82	8.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
298	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	83	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
299	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	84	8.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
300	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	85	12.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
301	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	86	6.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
302	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	87	15.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
303	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	88	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
304	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	89	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
305	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	90	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
306	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	91	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
307	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	92	20.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
308	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	93	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
309	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	94	6.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
310	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	95	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
311	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	96	6.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
312	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	97	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
313	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	98	8.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
314	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	99	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
315	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	100	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
316	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	101	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
317	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	102	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
318	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	102	4.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
319	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	103	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
320	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	104	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
321	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	105	10.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
322	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	105	12.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
323	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	106	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
324	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	107	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
325	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	108	7.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
326	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	109	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
327	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	110	8.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
328	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	111	6.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
329	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	112	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
330	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	113	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
331	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	112	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
332	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	114	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
333	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	115	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
334	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	116	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
335	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	117	7.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
336	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	118	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
337	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	119	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
338	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	120	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
339	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	121	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
340	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	122	4.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
341	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	123	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
342	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	124	10.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
343	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	125	4.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
344	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	126	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
345	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	127	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
346	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	128	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
347	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	129	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
348	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	130	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
349	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	131	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
350	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	132	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
351	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	133	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
352	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	134	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
353	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	135	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
354	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	136	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
355	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	137	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
356	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	138	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
357	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	139	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
358	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	140	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
359	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	141	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
360	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	142	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
361	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	143	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
362	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	144	5.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
363	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	145	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
364	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	146	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
365	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	147	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
366	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	148	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
367	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	149	4.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
368	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	150	3.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
369	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	151	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
370	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	152	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
371	2	2026-05-11	2026-05-11 21:38:54	1	AI助手: 蔬菜进货单	purchase_receipt	t	153	2.000	ai_message	111	1	2026-05-11 21:38:54	2026-05-11 21:38:54	f	\N	\N
372	2	2026-05-11	2026-05-11 21:48:42	1	AI助手: 把所有草莓的情况给我展示一下	inventory_query	f	\N	\N	ai_message	113	1	2026-05-11 21:48:42	2026-05-11 21:48:42	f	\N	\N
373	3	2026-05-30	2026-05-30 07:03:32	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	115	8	2026-05-30 07:03:32	2026-05-30 07:03:32	f	\N	\N
374	3	2026-05-30	2026-05-30 07:03:35	1	AI助手: 你好	other	f	\N	\N	ai_message	117	8	2026-05-30 07:03:35	2026-05-30 07:03:35	f	\N	\N
375	3	2026-05-30	2026-05-30 07:06:44	1	AI助手: 今日销售	sales_today_query	f	\N	\N	ai_message	119	8	2026-05-30 07:06:44	2026-05-30 07:06:44	f	\N	\N
376	3	2026-05-30	2026-05-30 07:06:47	1	AI助手: 进货建议	suggestions_query	f	\N	\N	ai_message	121	8	2026-05-30 07:06:47	2026-05-30 07:06:47	f	\N	\N
377	3	2026-05-30	2026-05-30 07:06:51	1	AI助手: 每日营运概览	daily_overview_query	f	\N	\N	ai_message	123	8	2026-05-30 07:06:51	2026-05-30 07:06:51	f	\N	\N
378	3	2026-05-30	2026-05-30 07:07:03	1	AI助手: 明天天气	weather_query	f	\N	\N	ai_message	125	8	2026-05-30 07:07:03	2026-05-30 07:07:03	f	\N	\N
379	1	2026-05-30	2026-05-30 07:12:19	1	AI助手: 你好	other	f	\N	\N	ai_message	127	12	2026-05-30 07:12:19	2026-05-30 07:12:19	f	\N	\N
380	1	2026-05-30	2026-05-30 07:12:46	1	AI助手: 看一下今天的每日营运概览	daily_overview_query	f	\N	\N	ai_message	129	12	2026-05-30 07:12:46	2026-05-30 07:12:46	f	\N	\N
381	1	2026-05-30	2026-05-30 07:12:59	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	131	12	2026-05-30 07:12:59	2026-05-30 07:12:59	f	\N	\N
382	1	2026-05-30	2026-05-30 07:13:09	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	133	12	2026-05-30 07:13:09	2026-05-30 07:13:09	f	\N	\N
383	1	2026-05-30	2026-05-30 07:17:02	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	135	12	2026-05-30 07:17:02	2026-05-30 07:17:02	f	\N	\N
384	1	2026-05-30	2026-05-30 07:44:50	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	137	12	2026-05-30 07:44:50	2026-05-30 07:44:50	f	\N	\N
385	1	2026-05-30	2026-05-30 07:59:31	1	AI助手: 123	other	f	\N	\N	ai_message	139	12	2026-05-30 07:59:31	2026-05-30 07:59:31	f	\N	\N
386	1	2026-05-30	2026-05-30 07:59:59	1	AI助手: 天气怎么样	weather_query	f	\N	\N	ai_message	141	12	2026-05-30 07:59:59	2026-05-30 07:59:59	f	\N	\N
387	1	2026-05-30	2026-05-30 08:08:35	1	AI助手: 好的	other	f	\N	\N	ai_message	143	12	2026-05-30 08:08:35	2026-05-30 08:08:35	f	\N	\N
388	1	2026-05-30	2026-05-30 08:09:09	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	145	12	2026-05-30 08:09:09	2026-05-30 08:09:09	f	\N	\N
389	1	2026-05-30	2026-05-30 08:09:20	1	AI助手: 你叫什么	other	f	\N	\N	ai_message	147	12	2026-05-30 08:09:20	2026-05-30 08:09:20	f	\N	\N
390	1	2026-05-30	2026-05-30 08:09:31	1	AI助手: 补录	other	f	\N	\N	ai_message	149	12	2026-05-30 08:09:31	2026-05-30 08:09:31	f	\N	\N
391	1	2026-05-30	2026-05-30 08:09:41	2	[失败 500] POST /api/ai/message	error	f	\N	\N	\N	\N	12	2026-05-30 08:09:41	2026-05-30 08:09:41	t	500	SQLSTATE[42S22]: Column not found: 1054 Unknown column 'date' in 'order clause' (Connection: mysql, Host: 127.0.0.1, Port: 3306, Database: laravel_app, SQL: select * from `sales_daily_summaries` where `store_id` = 1 and `product_id` = 8 order by `date` desc limit 7)
392	1	2026-05-30	2026-05-30 08:09:56	1	AI助手: 后端	other	f	\N	\N	ai_message	153	12	2026-05-30 08:09:56	2026-05-30 08:09:56	f	\N	\N
393	1	2026-05-30	2026-05-30 08:10:38	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	155	12	2026-05-30 08:10:38	2026-05-30 08:10:38	f	\N	\N
394	1	2026-05-30	2026-05-30 08:10:44	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	157	12	2026-05-30 08:10:44	2026-05-30 08:10:44	f	\N	\N
395	1	2026-05-30	2026-05-30 08:10:59	1	AI助手: 奇异果卖了一件	sale_report	t	78	-1.000	ai_message	159	12	2026-05-30 08:10:59	2026-05-30 08:10:59	f	\N	\N
396	1	2026-05-30	2026-05-30 08:11:06	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	161	12	2026-05-30 08:11:06	2026-05-30 08:11:06	f	\N	\N
397	1	2026-05-30	2026-05-30 08:12:00	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	163	12	2026-05-30 08:12:00	2026-05-30 08:12:00	f	\N	\N
398	1	2026-05-30	2026-05-30 08:12:53	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	165	12	2026-05-30 08:12:53	2026-05-30 08:12:53	f	\N	\N
399	1	2026-05-30	2026-05-30 08:16:59	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	167	12	2026-05-30 08:16:59	2026-05-30 08:16:59	f	\N	\N
400	1	2026-05-30	2026-05-30 08:17:04	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	169	12	2026-05-30 08:17:04	2026-05-30 08:17:04	f	\N	\N
401	1	2026-05-30	2026-05-30 08:17:39	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	171	12	2026-05-30 08:17:39	2026-05-30 08:17:39	f	\N	\N
402	1	2026-05-30	2026-05-30 08:17:48	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-05-30 08:17:48	2026-05-30 08:17:48	t	422	HTTP 422
403	1	2026-05-30	2026-05-30 08:18:30	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	173	12	2026-05-30 08:18:30	2026-05-30 08:18:30	f	\N	\N
404	1	2026-05-30	2026-05-30 08:19:00	1	AI助手: 你好	other	f	\N	\N	ai_message	175	12	2026-05-30 08:19:00	2026-05-30 08:19:00	f	\N	\N
405	1	2026-05-30	2026-05-30 08:24:31	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	177	12	2026-05-30 08:24:31	2026-05-30 08:24:31	f	\N	\N
406	1	2026-05-30	2026-05-30 08:28:36	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	179	12	2026-05-30 08:28:36	2026-05-30 08:28:36	f	\N	\N
407	1	2026-05-30	2026-05-30 08:28:59	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	181	12	2026-05-30 08:28:59	2026-05-30 08:28:59	f	\N	\N
408	1	2026-05-30	2026-05-30 08:29:20	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	183	12	2026-05-30 08:29:20	2026-05-30 08:29:20	f	\N	\N
409	1	2026-05-30	2026-05-30 08:29:26	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	185	12	2026-05-30 08:29:26	2026-05-30 08:29:26	f	\N	\N
410	1	2026-05-30	2026-05-30 08:29:50	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	187	12	2026-05-30 08:29:50	2026-05-30 08:29:50	f	\N	\N
411	1	2026-05-30	2026-05-30 08:31:16	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	189	12	2026-05-30 08:31:16	2026-05-30 08:31:16	f	\N	\N
412	1	2026-05-30	2026-05-30 08:31:43	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	191	12	2026-05-30 08:31:43	2026-05-30 08:31:43	f	\N	\N
413	1	2026-05-30	2026-05-30 08:32:12	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	193	12	2026-05-30 08:32:12	2026-05-30 08:32:12	f	\N	\N
414	1	2026-05-30	2026-05-30 08:40:42	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	195	12	2026-05-30 08:40:42	2026-05-30 08:40:42	f	\N	\N
415	1	2026-05-30	2026-05-30 08:41:11	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	197	12	2026-05-30 08:41:11	2026-05-30 08:41:11	f	\N	\N
416	1	2026-05-30	2026-05-30 08:42:53	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	199	12	2026-05-30 08:42:53	2026-05-30 08:42:53	f	\N	\N
417	1	2026-05-30	2026-05-30 08:47:36	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	201	12	2026-05-30 08:47:36	2026-05-30 08:47:36	f	\N	\N
418	1	2026-05-30	2026-05-30 08:47:56	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	203	12	2026-05-30 08:47:56	2026-05-30 08:47:56	f	\N	\N
419	1	2026-05-30	2026-05-30 08:48:13	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	205	12	2026-05-30 08:48:13	2026-05-30 08:48:13	f	\N	\N
420	1	2026-05-30	2026-05-30 08:48:36	1	AI助手: 看一下今天的操作日志	daily_logs_query	f	\N	\N	ai_message	207	12	2026-05-30 08:48:36	2026-05-30 08:48:36	f	\N	\N
421	1	2026-05-30	2026-05-30 08:53:01	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	209	12	2026-05-30 08:53:01	2026-05-30 08:53:01	f	\N	\N
422	1	2026-05-30	2026-05-30 08:53:14	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	211	12	2026-05-30 08:53:14	2026-05-30 08:53:14	f	\N	\N
423	1	2026-05-30	2026-05-30 08:54:01	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	213	12	2026-05-30 08:54:01	2026-05-30 08:54:01	f	\N	\N
424	1	2026-05-30	2026-05-30 08:54:11	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	215	12	2026-05-30 08:54:11	2026-05-30 08:54:11	f	\N	\N
425	1	2026-05-30	2026-05-30 08:58:41	1	AI助手: 你好	other	f	\N	\N	ai_message	217	12	2026-05-30 08:58:41	2026-05-30 08:58:41	f	\N	\N
426	1	2026-05-30	2026-05-30 08:59:38	1	AI助手: 你好	other	f	\N	\N	ai_message	219	12	2026-05-30 08:59:38	2026-05-30 08:59:38	f	\N	\N
427	1	2026-05-30	2026-05-30 09:00:22	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	221	12	2026-05-30 09:00:22	2026-05-30 09:00:22	f	\N	\N
428	1	2026-05-30	2026-05-30 09:00:33	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	223	12	2026-05-30 09:00:33	2026-05-30 09:00:33	f	\N	\N
429	1	2026-05-30	2026-05-30 09:02:33	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	225	12	2026-05-30 09:02:33	2026-05-30 09:02:33	f	\N	\N
430	1	2026-05-30	2026-05-30 09:02:43	1	AI助手: 1+15等于多少	other	f	\N	\N	ai_message	227	12	2026-05-30 09:02:43	2026-05-30 09:02:43	f	\N	\N
431	1	2026-05-30	2026-05-30 09:09:58	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	229	12	2026-05-30 09:09:58	2026-05-30 09:09:58	f	\N	\N
432	1	2026-05-30	2026-05-30 09:10:33	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	231	12	2026-05-30 09:10:33	2026-05-30 09:10:33	f	\N	\N
433	1	2026-05-30	2026-05-30 09:10:40	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	233	12	2026-05-30 09:10:40	2026-05-30 09:10:40	f	\N	\N
434	1	2026-05-30	2026-05-30 09:10:46	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	235	12	2026-05-30 09:10:46	2026-05-30 09:10:46	f	\N	\N
435	1	2026-05-30	2026-05-30 09:13:08	2	[失败 500] POST /api/ai/message	error	f	\N	\N	\N	\N	12	2026-05-30 09:13:08	2026-05-30 09:13:08	t	500	cURL error 28: Operation timed out after 60001 milliseconds with 0 bytes received (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) for https://tokens.fidelityai.net/v1/chat/completions
436	1	2026-05-30	2026-05-30 09:27:17	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	237	12	2026-05-30 09:27:17	2026-05-30 09:27:17	f	\N	\N
437	1	2026-05-30	2026-05-30 09:27:44	1	AI助手: 看一下今天的操作日志	daily_logs_query	f	\N	\N	ai_message	239	12	2026-05-30 09:27:44	2026-05-30 09:27:44	f	\N	\N
438	1	2026-05-30	2026-05-30 09:27:58	1	AI助手: 给我一些进货和促销建议	suggestions_query	f	\N	\N	ai_message	241	12	2026-05-30 09:27:58	2026-05-30 09:27:58	f	\N	\N
439	1	2026-05-30	2026-05-30 09:28:09	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	243	12	2026-05-30 09:28:09	2026-05-30 09:28:09	f	\N	\N
440	1	2026-05-30	2026-05-30 09:28:20	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	245	12	2026-05-30 09:28:20	2026-05-30 09:28:20	f	\N	\N
441	1	2026-05-30	2026-05-30 09:42:43	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	247	12	2026-05-30 09:42:43	2026-05-30 09:42:43	f	\N	\N
442	1	2026-05-30	2026-05-30 09:52:17	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	249	12	2026-05-30 09:52:17	2026-05-30 09:52:17	f	\N	\N
443	1	2026-05-30	2026-05-30 09:54:22	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	251	12	2026-05-30 09:54:22	2026-05-30 09:54:22	f	\N	\N
444	1	2026-05-30	2026-05-30 09:55:17	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	253	12	2026-05-30 09:55:17	2026-05-30 09:55:17	f	\N	\N
445	1	2026-05-30	2026-05-30 09:56:23	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	255	12	2026-05-30 09:56:23	2026-05-30 09:56:23	f	\N	\N
446	1	2026-05-30	2026-05-30 09:59:26	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	257	12	2026-05-30 09:59:26	2026-05-30 09:59:26	f	\N	\N
447	1	2026-05-30	2026-05-30 10:21:36	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	259	12	2026-05-30 10:21:36	2026-05-30 10:21:36	f	\N	\N
448	1	2026-05-30	2026-05-30 10:29:46	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	261	12	2026-05-30 10:29:46	2026-05-30 10:29:46	f	\N	\N
449	1	2026-05-30	2026-05-30 10:37:15	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	263	12	2026-05-30 10:37:15	2026-05-30 10:37:15	f	\N	\N
450	3	2026-05-30	2026-05-30 10:39:22	1	AI助手: 查今日库存	inventory_query	f	\N	\N	ai_message	265	8	2026-05-30 10:39:22	2026-05-30 10:39:22	f	\N	\N
451	1	2026-05-30	2026-05-30 10:50:49	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	267	12	2026-05-30 10:50:49	2026-05-30 10:50:49	f	\N	\N
452	1	2026-05-30	2026-05-30 10:54:35	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	269	12	2026-05-30 10:54:35	2026-05-30 10:54:35	f	\N	\N
453	1	2026-05-30	2026-05-30 10:56:45	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	271	12	2026-05-30 10:56:45	2026-05-30 10:56:45	f	\N	\N
454	1	2026-05-30	2026-05-30 10:56:53	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	273	12	2026-05-30 10:56:53	2026-05-30 10:56:53	f	\N	\N
455	1	2026-05-30	2026-05-30 10:57:04	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	275	12	2026-05-30 10:57:04	2026-05-30 10:57:04	f	\N	\N
456	1	2026-05-30	2026-05-30 11:27:51	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	277	12	2026-05-30 11:27:51	2026-05-30 11:27:51	f	\N	\N
457	1	2026-05-30	2026-05-30 11:28:00	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	279	12	2026-05-30 11:28:00	2026-05-30 11:28:00	f	\N	\N
458	1	2026-05-30	2026-05-30 11:28:09	1	AI助手: 写一个工作总结	other	f	\N	\N	ai_message	281	12	2026-05-30 11:28:09	2026-05-30 11:28:09	f	\N	\N
459	1	2026-05-30	2026-05-30 11:28:19	1	AI助手: 你叫什么	other	f	\N	\N	ai_message	283	12	2026-05-30 11:28:19	2026-05-30 11:28:19	f	\N	\N
460	1	2026-05-30	2026-05-30 11:28:31	1	AI助手: 香港到深圳怎么走	other	f	\N	\N	ai_message	285	12	2026-05-30 11:28:31	2026-05-30 11:28:31	f	\N	\N
461	1	2026-05-30	2026-05-30 12:09:48	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	287	12	2026-05-30 12:09:48	2026-05-30 12:09:48	f	\N	\N
462	1	2026-05-30	2026-05-30 12:16:53	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	289	12	2026-05-30 12:16:53	2026-05-30 12:16:53	f	\N	\N
463	1	2026-05-30	2026-05-30 12:22:22	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-05-30 12:22:22	2026-05-30 12:22:22	t	422	HTTP 422
464	1	2026-05-30	2026-05-30 12:22:49	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	291	12	2026-05-30 12:22:49	2026-05-30 12:22:49	f	\N	\N
465	1	2026-05-30	2026-05-30 12:35:09	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	293	12	2026-05-30 12:35:09	2026-05-30 12:35:09	f	\N	\N
466	1	2026-05-30	2026-05-30 12:35:16	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	295	12	2026-05-30 12:35:16	2026-05-30 12:35:16	f	\N	\N
467	1	2026-05-30	2026-05-30 12:53:40	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	297	12	2026-05-30 12:53:40	2026-05-30 12:53:40	f	\N	\N
468	1	2026-05-30	2026-05-30 12:56:07	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	299	12	2026-05-30 12:56:07	2026-05-30 12:56:07	f	\N	\N
469	1	2026-05-30	2026-05-30 12:59:27	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	301	12	2026-05-30 12:59:27	2026-05-30 12:59:27	f	\N	\N
470	1	2026-05-30	2026-05-30 12:59:41	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	303	12	2026-05-30 12:59:41	2026-05-30 12:59:41	f	\N	\N
471	1	2026-05-30	2026-05-30 13:03:03	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	305	12	2026-05-30 13:03:03	2026-05-30 13:03:03	f	\N	\N
472	1	2026-05-30	2026-05-30 13:03:40	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	307	12	2026-05-30 13:03:40	2026-05-30 13:03:40	f	\N	\N
473	1	2026-05-30	2026-05-30 13:06:34	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	309	12	2026-05-30 13:06:34	2026-05-30 13:06:34	f	\N	\N
474	1	2026-05-30	2026-05-30 13:06:54	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	311	12	2026-05-30 13:06:54	2026-05-30 13:06:54	f	\N	\N
475	1	2026-05-30	2026-05-30 13:08:20	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	313	12	2026-05-30 13:08:20	2026-05-30 13:08:20	f	\N	\N
476	1	2026-05-30	2026-05-30 13:09:06	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	315	12	2026-05-30 13:09:06	2026-05-30 13:09:06	f	\N	\N
477	1	2026-05-30	2026-05-30 13:11:54	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	317	12	2026-05-30 13:11:54	2026-05-30 13:11:54	f	\N	\N
478	1	2026-05-30	2026-05-30 13:15:18	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	319	12	2026-05-30 13:15:18	2026-05-30 13:15:18	f	\N	\N
479	1	2026-05-30	2026-05-30 14:32:33	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	321	12	2026-05-30 14:32:33	2026-05-30 14:32:33	f	\N	\N
480	1	2026-05-30	2026-05-30 14:33:53	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	323	12	2026-05-30 14:33:53	2026-05-30 14:33:53	f	\N	\N
481	3	2026-05-30	2026-05-30 15:04:02	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	325	8	2026-05-30 15:04:02	2026-05-30 15:04:02	f	\N	\N
482	1	2026-05-30	2026-05-30 15:29:27	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	327	12	2026-05-30 15:29:27	2026-05-30 15:29:27	f	\N	\N
483	1	2026-05-30	2026-05-30 15:30:11	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	329	12	2026-05-30 15:30:11	2026-05-30 15:30:11	f	\N	\N
484	1	2026-05-30	2026-05-30 15:30:31	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-05-30 15:30:31	2026-05-30 15:30:31	t	422	HTTP 422
485	1	2026-05-30	2026-05-30 16:04:05	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	331	12	2026-05-30 16:04:05	2026-05-30 16:04:05	f	\N	\N
486	1	2026-05-30	2026-05-30 16:05:10	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	333	12	2026-05-30 16:05:10	2026-05-30 16:05:10	f	\N	\N
487	1	2026-05-30	2026-05-30 16:05:23	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	335	12	2026-05-30 16:05:23	2026-05-30 16:05:23	f	\N	\N
488	1	2026-05-30	2026-05-30 16:05:54	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	337	12	2026-05-30 16:05:54	2026-05-30 16:05:54	f	\N	\N
489	1	2026-05-30	2026-05-30 16:06:04	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	339	12	2026-05-30 16:06:04	2026-05-30 16:06:04	f	\N	\N
490	1	2026-05-30	2026-05-30 16:06:16	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	341	12	2026-05-30 16:06:16	2026-05-30 16:06:16	f	\N	\N
491	1	2026-05-30	2026-05-30 16:06:30	1	AI助手: 进货2斤苹果	purchase_receipt	t	8	2.000	ai_message	343	12	2026-05-30 16:06:30	2026-05-30 16:06:30	f	\N	\N
492	1	2026-05-30	2026-05-30 16:06:43	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	345	12	2026-05-30 16:06:43	2026-05-30 16:06:43	f	\N	\N
493	1	2026-05-30	2026-05-30 16:06:50	1	AI助手: 查一下最近的进货单	purchase_orders_query	f	\N	\N	ai_message	347	12	2026-05-30 16:06:50	2026-05-30 16:06:50	f	\N	\N
494	1	2026-05-30	2026-05-30 16:15:09	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	349	12	2026-05-30 16:15:09	2026-05-30 16:15:09	f	\N	\N
495	1	2026-05-30	2026-05-30 16:15:20	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	351	12	2026-05-30 16:15:20	2026-05-30 16:15:20	f	\N	\N
496	1	2026-05-30	2026-05-30 18:47:05	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	353	12	2026-05-30 18:47:05	2026-05-30 18:47:05	f	\N	\N
497	1	2026-05-30	2026-05-30 18:47:27	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	355	12	2026-05-30 18:47:27	2026-05-30 18:47:27	f	\N	\N
498	1	2026-05-30	2026-05-30 18:47:36	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	357	12	2026-05-30 18:47:36	2026-05-30 18:47:36	f	\N	\N
499	1	2026-05-30	2026-05-30 19:21:39	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	359	12	2026-05-30 19:21:39	2026-05-30 19:21:39	f	\N	\N
500	1	2026-05-30	2026-05-30 19:26:38	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	361	12	2026-05-30 19:26:38	2026-05-30 19:26:38	f	\N	\N
501	1	2026-05-30	2026-05-30 19:27:48	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	363	12	2026-05-30 19:27:48	2026-05-30 19:27:48	f	\N	\N
502	1	2026-05-30	2026-05-30 19:57:18	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	365	12	2026-05-30 19:57:18	2026-05-30 19:57:18	f	\N	\N
503	1	2026-05-30	2026-05-30 21:17:22	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	367	12	2026-05-30 21:17:22	2026-05-30 21:17:22	f	\N	\N
504	1	2026-05-30	2026-05-30 21:17:45	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	369	12	2026-05-30 21:17:45	2026-05-30 21:17:45	f	\N	\N
505	1	2026-05-30	2026-05-30 21:18:53	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	371	12	2026-05-30 21:18:53	2026-05-30 21:18:53	f	\N	\N
506	1	2026-05-30	2026-05-30 21:46:44	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	373	12	2026-05-30 21:46:44	2026-05-30 21:46:44	f	\N	\N
507	1	2026-05-30	2026-05-30 21:47:03	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	375	12	2026-05-30 21:47:03	2026-05-30 21:47:03	f	\N	\N
508	1	2026-05-30	2026-05-30 21:47:43	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	377	12	2026-05-30 21:47:43	2026-05-30 21:47:43	f	\N	\N
509	1	2026-05-30	2026-05-30 21:50:27	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	379	12	2026-05-30 21:50:27	2026-05-30 21:50:27	f	\N	\N
510	1	2026-05-30	2026-05-30 21:51:43	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	381	12	2026-05-30 21:51:43	2026-05-30 21:51:43	f	\N	\N
511	1	2026-05-30	2026-05-30 21:53:43	1	AI助手: 给我一些进货和促销建议	suggestions_query	f	\N	\N	ai_message	383	12	2026-05-30 21:53:43	2026-05-30 21:53:43	f	\N	\N
512	1	2026-05-30	2026-05-30 21:54:02	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	385	12	2026-05-30 21:54:02	2026-05-30 21:54:02	f	\N	\N
513	1	2026-05-30	2026-05-30 21:54:34	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	387	12	2026-05-30 21:54:34	2026-05-30 21:54:34	f	\N	\N
514	1	2026-05-30	2026-05-30 21:55:05	1	AI助手: 刚刚有2斤草莓是坏的	waste_report	t	38	0.000	ai_message	389	12	2026-05-30 21:55:05	2026-05-30 21:55:05	f	\N	\N
515	1	2026-05-30	2026-05-30 21:55:14	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	391	12	2026-05-30 21:55:14	2026-05-30 21:55:14	f	\N	\N
516	1	2026-05-30	2026-05-30 21:55:21	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	393	12	2026-05-30 21:55:21	2026-05-30 21:55:21	f	\N	\N
517	1	2026-05-30	2026-05-30 21:57:36	1	AI助手: 橘子卖不动了	suggestions_query	f	\N	\N	ai_message	395	12	2026-05-30 21:57:36	2026-05-30 21:57:36	f	\N	\N
518	1	2026-05-31	2026-05-31 04:51:49	2	损耗登记: 苹果 2斤 原因:变质	waste_report	t	8	-2.000	\N	\N	12	2026-05-31 04:51:59	2026-05-31 04:51:59	f	\N	\N
519	1	2026-05-31	2026-05-31 05:05:02	2	损耗登记: 栗子 2斤 原因:变质	waste_report	t	154	0.000	\N	\N	12	2026-05-31 05:05:10	2026-05-31 05:05:10	f	\N	\N
520	1	2026-05-31	2026-05-31 05:06:30	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	397	12	2026-05-31 05:06:30	2026-05-31 05:06:30	f	\N	\N
521	1	2026-05-31	2026-05-31 05:10:47	1	AI助手: 今天卖了多少	sales_today_query	f	\N	\N	ai_message	399	12	2026-05-31 05:10:47	2026-05-31 05:10:47	f	\N	\N
522	1	2026-05-31	2026-05-31 06:08:33	2	销售报表上传：gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png，处理 6 条，失败 0 条	sale_report	t	\N	\N	\N	\N	12	2026-05-31 06:08:34	2026-05-31 06:08:34	f	\N	\N
523	1	2026-05-31	2026-05-31 06:20:06	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	401	12	2026-05-31 06:20:06	2026-05-31 06:20:06	f	\N	\N
524	1	2026-05-31	2026-05-31 06:27:08	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	403	12	2026-05-31 06:27:08	2026-05-31 06:27:08	f	\N	\N
525	1	2026-05-31	2026-05-31 06:33:23	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	405	12	2026-05-31 06:33:23	2026-05-31 06:33:23	f	\N	\N
526	1	2026-05-31	2026-05-31 06:35:48	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	407	12	2026-05-31 06:35:48	2026-05-31 06:35:48	f	\N	\N
527	1	2026-05-31	2026-05-31 06:39:16	1	AI助手: 给我一些进货和促销建议	suggestions_query	f	\N	\N	ai_message	409	12	2026-05-31 06:39:16	2026-05-31 06:39:16	f	\N	\N
528	1	2026-05-31	2026-05-31 06:40:06	1	AI助手: 查一下今日库存	inventory_query	f	\N	\N	ai_message	411	12	2026-05-31 06:40:06	2026-05-31 06:40:06	f	\N	\N
529	1	2026-05-31	2026-05-31 07:32:04	2	进货收货: PO-20260531-00001 共 6 个SKU	stock_in	t	\N	\N	purchase_order	55	12	2026-05-31 07:32:04	2026-05-31 07:32:04	f	\N	\N
530	1	2026-05-31	2026-05-31 08:00:37	2	[失败 500] POST /api/ai/message	error	f	\N	\N	\N	\N	12	2026-05-31 08:00:37	2026-05-31 08:00:37	t	500	SQLSTATE[42S22]: Column not found: 1054 Unknown column 'date' in 'order clause' (Connection: mysql, Host: 127.0.0.1, Port: 3306, Database: laravel_app, SQL: select * from `sales_daily_summaries` where `store_id` = 1 and `product_id` = 3 order by `date` desc limit 7)
531	1	2026-05-31	2026-05-31 08:00:53	1	AI助手: 你好	other	f	\N	\N	ai_message	415	12	2026-05-31 08:00:53	2026-05-31 08:00:53	f	\N	\N
532	1	2026-05-31	2026-05-31 08:50:24	1	AI助手: 你好	other	f	\N	\N	ai_message	417	12	2026-05-31 08:50:24	2026-05-31 08:50:24	f	\N	\N
533	1	2026-05-31	2026-05-31 08:50:31	1	AI助手: 你好	other	f	\N	\N	ai_message	419	12	2026-05-31 08:50:31	2026-05-31 08:50:31	f	\N	\N
534	1	2026-05-31	2026-05-31 08:53:06	1	AI助手: 你好	other	f	\N	\N	ai_message	421	12	2026-05-31 08:53:06	2026-05-31 08:53:06	f	\N	\N
535	1	2026-05-31	2026-05-31 09:38:11	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	423	12	2026-05-31 09:38:11	2026-05-31 09:38:11	f	\N	\N
536	1	2026-05-31	2026-05-31 09:38:17	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	425	12	2026-05-31 09:38:17	2026-05-31 09:38:17	f	\N	\N
537	1	2026-05-31	2026-05-31 09:43:07	1	AI助手: 库存	inventory_query	f	\N	\N	ai_message	427	12	2026-05-31 09:43:07	2026-05-31 09:43:07	f	\N	\N
538	1	2026-05-31	2026-05-31 09:43:29	1	AI助手: 损耗	other	f	\N	\N	ai_message	429	12	2026-05-31 09:43:29	2026-05-31 09:43:29	f	\N	\N
539	1	2026-05-31	2026-05-31 19:23:19	1	AI助手: 我现在能干点什么？	other	f	\N	\N	ai_message	431	12	2026-05-31 19:23:19	2026-05-31 19:23:19	f	\N	\N
540	1	2026-06-01	2026-06-01 18:07:49	1	AI助手: 保单查询	other	f	\N	\N	ai_message	433	12	2026-06-01 18:07:49	2026-06-01 18:07:49	f	\N	\N
541	1	2026-06-01	2026-06-01 18:13:46	1	AI助手: 今天有没有录单	daily_logs_query	f	\N	\N	ai_message	435	12	2026-06-01 18:13:46	2026-06-01 18:13:46	f	\N	\N
542	1	2026-06-01	2026-06-01 18:14:07	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	437	12	2026-06-01 18:14:07	2026-06-01 18:14:07	f	\N	\N
543	1	2026-06-02	2026-06-02 08:24:03	1	AI助手: 录销售	other	f	\N	\N	ai_message	439	12	2026-06-02 08:24:03	2026-06-02 08:24:03	f	\N	\N
544	1	2026-06-02	2026-06-02 15:30:34	2	损耗登记: 精品草莓 5斤 原因:运输损坏	waste_report	t	38	0.000	\N	\N	12	2026-06-02 15:30:40	2026-06-02 15:30:40	f	\N	\N
545	1	2026-06-02	2026-06-02 16:23:33	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	441	12	2026-06-02 16:23:33	2026-06-02 16:23:33	f	\N	\N
546	1	2026-06-02	2026-06-02 16:23:36	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	443	12	2026-06-02 16:23:36	2026-06-02 16:23:36	f	\N	\N
547	1	2026-06-03	2026-06-03 00:58:29	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	445	12	2026-06-03 00:58:29	2026-06-03 00:58:29	f	\N	\N
548	1	2026-06-03	2026-06-03 02:08:05	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	447	12	2026-06-03 02:08:05	2026-06-03 02:08:05	f	\N	\N
549	1	2026-06-03	2026-06-03 09:03:59	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	449	12	2026-06-03 09:03:59	2026-06-03 09:03:59	f	\N	\N
550	1	2026-06-03	2026-06-03 17:32:03	1	AI助手: 你好	other	f	\N	\N	ai_message	451	12	2026-06-03 17:32:03	2026-06-03 17:32:03	f	\N	\N
551	1	2026-06-03	2026-06-03 17:46:00	1	AI助手: 你好	other	f	\N	\N	ai_message	453	12	2026-06-03 17:46:00	2026-06-03 17:46:00	f	\N	\N
552	1	2026-06-03	2026-06-03 17:47:58	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	455	12	2026-06-03 17:47:58	2026-06-03 17:47:58	f	\N	\N
553	1	2026-06-03	2026-06-03 17:48:07	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	457	12	2026-06-03 17:48:07	2026-06-03 17:48:07	f	\N	\N
554	1	2026-06-03	2026-06-03 17:48:20	1	AI助手: 你是说	other	f	\N	\N	ai_message	459	12	2026-06-03 17:48:20	2026-06-03 17:48:20	f	\N	\N
555	1	2026-06-03	2026-06-03 20:12:56	2	损耗登记: 番茄 1斤 原因:变质	waste_report	t	4	-1.000	\N	\N	12	2026-06-03 20:13:08	2026-06-03 20:13:08	f	\N	\N
556	1	2026-06-03	2026-06-03 20:29:59	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	461	12	2026-06-03 20:29:59	2026-06-03 20:29:59	f	\N	\N
557	1	2026-06-03	2026-06-03 20:30:47	1	AI助手: 牛油果出货一件	sale_report	t	76	-1.000	ai_message	463	12	2026-06-03 20:30:47	2026-06-03 20:30:47	f	\N	\N
558	1	2026-06-03	2026-06-03 20:45:49	2	销售报表上传：零售报表分析-零售-零售汇总_1774399133339.xlsx，处理 50 条，失败 0 条	sale_report	t	\N	\N	\N	\N	8	2026-06-03 20:45:49	2026-06-03 20:45:49	f	\N	\N
559	1	2026-06-07	2026-06-07 10:55:57	1	AI助手: 明天天气怎么样	other	f	\N	\N	ai_message	465	12	2026-06-07 10:55:57	2026-06-07 10:55:57	f	\N	\N
560	1	2026-06-07	2026-06-07 10:55:59	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	467	12	2026-06-07 10:55:59	2026-06-07 10:55:59	f	\N	\N
561	1	2026-06-07	2026-06-07 11:01:36	1	AI助手: 你好	other	f	\N	\N	ai_message	469	12	2026-06-07 11:01:36	2026-06-07 11:01:36	f	\N	\N
562	1	2026-06-09	2026-06-09 08:26:21	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	471	12	2026-06-09 08:26:21	2026-06-09 08:26:21	f	\N	\N
563	1	2026-06-09	2026-06-09 08:26:33	1	AI助手: 查一下最近的进货单	other	f	\N	\N	ai_message	473	12	2026-06-09 08:26:33	2026-06-09 08:26:33	f	\N	\N
564	1	2026-06-09	2026-06-09 08:28:44	1	AI助手: 查一下客户王明	other	f	\N	\N	ai_message	475	12	2026-06-09 08:28:44	2026-06-09 08:28:44	f	\N	\N
565	1	2026-06-11	2026-06-11 22:13:17	1	AI助手: 你好	other	f	\N	\N	ai_message	477	12	2026-06-11 22:13:17	2026-06-11 22:13:17	f	\N	\N
566	1	2026-06-11	2026-06-11 22:17:22	1	AI助手: 你好	other	f	\N	\N	ai_message	479	12	2026-06-11 22:17:22	2026-06-11 22:17:22	f	\N	\N
567	1	2026-06-11	2026-06-11 22:17:30	1	AI助手: 你好	other	f	\N	\N	ai_message	481	12	2026-06-11 22:17:30	2026-06-11 22:17:30	f	\N	\N
568	1	2026-06-11	2026-06-11 22:18:43	1	AI助手: 你好	other	f	\N	\N	ai_message	483	12	2026-06-11 22:18:43	2026-06-11 22:18:43	f	\N	\N
569	1	2026-06-11	2026-06-11 22:18:51	1	AI助手: 你好	other	f	\N	\N	ai_message	485	12	2026-06-11 22:18:51	2026-06-11 22:18:51	f	\N	\N
570	1	2026-06-11	2026-06-11 22:19:42	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	487	12	2026-06-11 22:19:42	2026-06-11 22:19:42	f	\N	\N
571	1	2026-06-11	2026-06-11 22:19:50	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	489	12	2026-06-11 22:19:50	2026-06-11 22:19:50	f	\N	\N
572	1	2026-06-11	2026-06-11 22:20:46	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	491	12	2026-06-11 22:20:46	2026-06-11 22:20:46	f	\N	\N
573	1	2026-06-11	2026-06-11 22:20:55	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	493	12	2026-06-11 22:20:55	2026-06-11 22:20:55	f	\N	\N
574	1	2026-06-11	2026-06-11 22:21:00	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	495	12	2026-06-11 22:21:00	2026-06-11 22:21:00	f	\N	\N
575	1	2026-06-11	2026-06-11 22:24:11	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	497	12	2026-06-11 22:24:11	2026-06-11 22:24:11	f	\N	\N
576	1	2026-06-11	2026-06-11 22:42:12	1	AI助手: 你在哪里	other	f	\N	\N	ai_message	499	12	2026-06-11 22:42:12	2026-06-11 22:42:12	f	\N	\N
577	1	2026-06-11	2026-06-11 22:42:25	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	501	12	2026-06-11 22:42:25	2026-06-11 22:42:25	f	\N	\N
578	1	2026-06-11	2026-06-11 23:36:41	1	AI助手: 当前产能进度如何	other	f	\N	\N	ai_message	503	12	2026-06-11 23:36:41	2026-06-11 23:36:41	f	\N	\N
579	1	2026-06-11	2026-06-11 23:36:49	1	AI助手: 查一下生产订单	other	f	\N	\N	ai_message	505	12	2026-06-11 23:36:49	2026-06-11 23:36:49	f	\N	\N
580	1	2026-06-11	2026-06-11 23:36:54	1	AI助手: 物料还剩多少	inventory_query	f	\N	\N	ai_message	507	12	2026-06-11 23:36:54	2026-06-11 23:36:54	f	\N	\N
581	1	2026-06-11	2026-06-11 23:37:54	1	AI助手: 帮客户办一张会员卡	customer_add	f	\N	\N	ai_message	509	12	2026-06-11 23:37:54	2026-06-11 23:37:54	f	\N	\N
582	1	2026-06-12	2026-06-12 00:19:48	1	AI助手: 帮我登记今天的上新款	purchase_receipt	f	\N	\N	ai_message	511	12	2026-06-12 00:19:48	2026-06-12 00:19:48	f	\N	\N
583	1	2026-06-12	2026-06-12 00:20:16	1	AI助手: 查一下今天的订单	customer_orders_query	f	\N	\N	ai_message	513	12	2026-06-12 00:20:16	2026-06-12 00:20:16	f	\N	\N
584	1	2026-06-12	2026-06-12 00:21:40	1	AI助手: 有哪些客户需要回访	other	f	\N	\N	ai_message	515	12	2026-06-12 00:21:40	2026-06-12 00:21:40	f	\N	\N
585	1	2026-06-12	2026-06-12 00:42:48	1	AI助手: 查一下账户情况	other	f	\N	\N	ai_message	517	12	2026-06-12 00:42:48	2026-06-12 00:42:48	f	\N	\N
586	1	2026-06-12	2026-06-12 00:42:52	1	AI助手: 帮我对账	other	f	\N	\N	ai_message	519	12	2026-06-12 00:42:52	2026-06-12 00:42:52	f	\N	\N
587	1	2026-06-12	2026-06-12 00:42:54	1	AI助手: 查一下客户信息	customer_query	f	\N	\N	ai_message	521	12	2026-06-12 00:42:54	2026-06-12 00:42:54	f	\N	\N
588	1	2026-06-12	2026-06-12 00:43:05	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	523	12	2026-06-12 00:43:05	2026-06-12 00:43:05	f	\N	\N
589	1	2026-06-12	2026-06-12 00:43:23	1	AI助手: 有哪些风控预警	other	f	\N	\N	ai_message	525	12	2026-06-12 00:43:23	2026-06-12 00:43:23	f	\N	\N
590	1	2026-06-12	2026-06-12 05:21:58	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	527	12	2026-06-12 05:21:58	2026-06-12 05:21:58	f	\N	\N
591	1	2026-06-12	2026-06-12 05:29:32	1	AI助手: 有哪些客户需要跟进	other	f	\N	\N	ai_message	529	12	2026-06-12 05:29:32	2026-06-12 05:29:32	f	\N	\N
592	1	2026-06-12	2026-06-12 11:06:22	1	AI助手: 今天的销售概况	daily_overview_query	f	\N	\N	ai_message	531	12	2026-06-12 11:06:22	2026-06-12 11:06:22	f	\N	\N
593	1	2026-06-12	2026-06-12 11:46:29	1	AI助手: 今日进货苹果100斤	purchase_receipt	t	8	100.000	ai_message	533	12	2026-06-12 11:46:29	2026-06-12 11:46:29	f	\N	\N
594	1	2026-06-12	2026-06-12 11:47:01	1	AI助手: 哪些货品需要备货了	suggestions_query	f	\N	\N	ai_message	535	12	2026-06-12 11:47:01	2026-06-12 11:47:01	f	\N	\N
595	1	2026-06-12	2026-06-12 19:43:26	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	537	12	2026-06-12 19:43:26	2026-06-12 19:43:26	f	\N	\N
596	1	2026-06-12	2026-06-12 19:43:34	1	AI助手: 明天天气怎么样	weather_query	f	\N	\N	ai_message	539	12	2026-06-12 19:43:34	2026-06-12 19:43:34	f	\N	\N
597	1	2026-06-12	2026-06-12 20:13:32	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	541	12	2026-06-12 20:13:32	2026-06-12 20:13:32	f	\N	\N
598	1	2026-06-12	2026-06-12 20:14:37	1	AI助手: 查一下今天的订单情况	customer_orders_query	f	\N	\N	ai_message	543	12	2026-06-12 20:14:37	2026-06-12 20:14:37	f	\N	\N
599	1	2026-06-12	2026-06-12 20:14:58	1	AI助手: 最近的经营数据报表	daily_overview_query	f	\N	\N	ai_message	545	12	2026-06-12 20:14:58	2026-06-12 20:14:58	f	\N	\N
600	1	2026-06-12	2026-06-12 20:15:54	1	AI助手: 请帮我规划一套电商产品主图和详情图的设计方案，包括构图建议、文案布局、色彩搭配。请描述你的产品：	other	f	\N	\N	ai_message	547	12	2026-06-12 20:15:54	2026-06-12 20:15:54	f	\N	\N
601	1	2026-06-13	2026-06-13 09:46:26	1	AI助手: 今天的生产概况	other	f	\N	\N	ai_message	549	12	2026-06-13 09:46:26	2026-06-13 09:46:26	f	\N	\N
602	1	2026-06-13	2026-06-13 09:46:30	1	AI助手: 物料还剩多少	other	f	\N	\N	ai_message	551	12	2026-06-13 09:46:30	2026-06-13 09:46:30	f	\N	\N
603	1	2026-06-13	2026-06-13 09:46:33	1	AI助手: 明天天气怎么样	other	f	\N	\N	ai_message	553	12	2026-06-13 09:46:33	2026-06-13 09:46:33	f	\N	\N
604	1	2026-06-13	2026-06-13 09:57:39	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	555	12	2026-06-13 09:57:39	2026-06-13 09:57:39	f	\N	\N
605	1	2026-06-13	2026-06-13 17:39:57	1	AI助手: 今天的什么品种卖的好	other	f	\N	\N	ai_message	557	12	2026-06-13 17:39:57	2026-06-13 17:39:57	f	\N	\N
606	1	2026-06-13	2026-06-13 18:18:29	1	AI助手: 最近哪些款式卖得好	other	f	\N	\N	ai_message	559	12	2026-06-13 18:18:29	2026-06-13 18:18:29	f	\N	\N
607	1	2026-06-14	2026-06-14 03:04:19	1	AI助手: 你好	other	f	\N	\N	ai_message	561	12	2026-06-14 03:04:19	2026-06-14 03:04:19	f	\N	\N
608	1	2026-06-14	2026-06-14 03:06:17	1	AI助手: 你好	other	f	\N	\N	ai_message	563	12	2026-06-14 03:06:17	2026-06-14 03:06:17	f	\N	\N
609	1	2026-06-14	2026-06-14 03:21:49	2	[失败 422] POST /api/ai/voice	error	f	\N	\N	\N	\N	12	2026-06-14 03:21:49	2026-06-14 03:21:49	t	422	HTTP 422
610	1	2026-06-14	2026-06-14 03:41:22	1	AI助手: 需要补哪些货	other	f	\N	\N	ai_message	565	12	2026-06-14 03:41:22	2026-06-14 03:41:22	f	\N	\N
611	1	2026-06-14	2026-06-14 03:41:32	1	AI助手: 现在有哪些促销	other	f	\N	\N	ai_message	567	12	2026-06-14 03:41:32	2026-06-14 03:41:32	f	\N	\N
612	1	2026-06-14	2026-06-14 03:41:43	1	AI助手: 现在有哪些促销	other	f	\N	\N	ai_message	569	12	2026-06-14 03:41:43	2026-06-14 03:41:43	f	\N	\N
613	1	2026-06-14	2026-06-14 08:13:33	1	AI助手: 明天天气怎么样	other	f	\N	\N	ai_message	571	12	2026-06-14 08:13:33	2026-06-14 08:13:33	f	\N	\N
614	1	2026-06-14	2026-06-14 08:37:38	1	AI助手: 明天天气怎么样	other	f	\N	\N	ai_message	573	12	2026-06-14 08:37:38	2026-06-14 08:37:38	f	\N	\N
615	1	2026-06-14	2026-06-14 12:17:16	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	575	12	2026-06-14 12:17:16	2026-06-14 12:17:16	f	\N	\N
616	1	2026-06-14	2026-06-14 12:17:38	1	AI助手: 帮我对账	other	f	\N	\N	ai_message	577	12	2026-06-14 12:17:38	2026-06-14 12:17:38	f	\N	\N
617	1	2026-06-14	2026-06-14 12:17:42	1	AI助手: 你能帮我做什么	other	f	\N	\N	ai_message	579	12	2026-06-14 12:17:42	2026-06-14 12:17:42	f	\N	\N
618	1	2026-06-14	2026-06-14 16:21:33	1	AI助手: 最近哪些项目最受欢迎	other	f	\N	\N	ai_message	581	12	2026-06-14 16:21:33	2026-06-14 16:21:33	f	\N	\N
619	1	2026-06-14	2026-06-14 16:21:58	1	AI助手: 你好	other	f	\N	\N	ai_message	583	12	2026-06-14 16:21:58	2026-06-14 16:21:58	f	\N	\N
620	1	2026-06-14	2026-06-14 16:25:29	1	AI助手: 你好	other	f	\N	\N	ai_message	585	12	2026-06-14 16:25:29	2026-06-14 16:25:29	f	\N	\N
621	1	2026-06-15	2026-06-15 03:52:32	1	AI助手: 你好	other	f	\N	\N	ai_message	587	12	2026-06-15 03:52:32	2026-06-15 03:52:32	f	\N	\N
\.


--
-- Data for Name: damage_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.damage_records (id, store_id, product_id, purchase_order_item_id, supplier_id, qty, unit_cost, total_claimed, reason, image_paths, status, occurred_at, operator_id, notes, created_at, updated_at, deleted_at) FROM stdin;
1	1	3	62	1	10.000	0.8000	8.00	变质	\N	1	2026-05-11 07:24:17	12	AI录入	2026-05-11 07:24:17	2026-05-11 07:24:17	\N
2	1	8	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 19:51:10	12	AI录入	2026-05-11 19:51:10	2026-05-11 19:51:10	\N
3	1	8	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 19:51:22	12	AI录入	2026-05-11 19:51:22	2026-05-11 19:51:22	\N
4	1	9	70	1	2.000	3.2000	6.40	变质	\N	1	2026-05-11 20:01:53	13	AI录入	2026-05-11 20:01:53	2026-05-11 20:01:53	\N
5	1	37	\N	\N	1.095	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
6	1	65	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
7	1	66	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
8	1	2	\N	\N	2.274	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
9	1	67	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
10	1	68	\N	\N	5.982	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
11	1	69	\N	\N	1.000	\N	\N	变质	\N	1	2026-05-11 21:02:17	12	AI录入	2026-05-11 21:02:17	2026-05-11 21:02:17	\N
12	1	37	\N	\N	1.410	\N	\N	变质	\N	1	2026-05-11 21:03:03	12	AI录入	2026-05-11 21:03:03	2026-05-11 21:03:03	\N
13	1	38	\N	\N	2.000	\N	\N	变质	\N	1	2026-05-30 21:55:05	12	AI录入	2026-05-30 21:55:05	2026-05-30 21:55:05	\N
14	1	8	319	\N	2.000	0.0000	\N	变质	["/storage/damage/1/2026-05-31/70107267-c4d2-41b5-88cb-d1efbdfea348.jpg"]	1	2026-05-31 04:51:49	12	\N	2026-05-31 04:51:59	2026-05-31 04:51:59	\N
15	1	154	\N	\N	2.000	\N	\N	变质	\N	1	2026-05-31 05:05:02	12	\N	2026-05-31 05:05:10	2026-05-31 05:05:10	\N
16	1	38	\N	\N	5.000	\N	\N	运输损坏	\N	1	2026-06-02 15:30:34	12	\N	2026-06-02 15:30:40	2026-06-02 15:30:40	\N
17	1	4	225	\N	1.000	0.0000	\N	变质	["\\/storage\\/damage\\/1\\/2026-06-03\\/963002d2-46d4-4264-9f25-d73d7f0d884d.jpg"]	1	2026-06-03 20:12:56	12	\N	2026-06-03 20:13:08	2026-06-03 20:13:08	\N
\.


--
-- Data for Name: dashboard_configs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dashboard_configs (id, user_id, store_id, name, scope, widgets, filters, refresh_interval, is_default, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: employee_store_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employee_store_history (id, employee_id, from_store_id, to_store_id, effective_date, reason, approved_by, created_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.employees (id, organization_id, user_id, current_store_id, employee_no, name, phone, id_card_no, gender, birth_date, education, "position", position_level, hire_date, contract_expire_date, probation_end_date, status, resign_date, resign_reason, base_salary, emergency_contact, emergency_phone, skills, notes, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: expense_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.expense_categories (id, organization_id, parent_id, name, code, is_cogs, sort_order, created_at, updated_at, deleted_at) FROM stdin;
1	1	\N	原材料采购	RAW	t	1	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
2	1	\N	水电费	UTIL	f	2	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
3	1	\N	人工费用	LAB	f	3	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
4	1	\N	耗材物料	SUP	f	4	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
5	1	\N	租金	RENT	f	5	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.expenses (id, store_id, category_id, expense_no, amount, expense_date, description, input_method, ai_session_message_id, attachment_urls, vendor_name, supplier_id, payment_method, payment_status, created_by, approved_by, approved_at, created_at, updated_at, deleted_at) FROM stdin;
1	2	1	EXP-XWH-001	3850.00	2026-03-15	\N	1	\N	\N	新鲜直送农场	\N	1	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
2	2	1	EXP-XWH-002	2200.00	2026-03-17	\N	1	\N	\N	港鲜肉类批发	\N	1	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
3	2	2	EXP-XWH-003	680.00	2026-03-19	\N	1	\N	\N	中华电力	\N	3	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
4	2	4	EXP-XWH-004	320.50	2026-03-20	\N	1	\N	\N	包装袋/托盘	\N	1	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
5	2	1	EXP-XWH-005	4100.00	2026-03-21	\N	1	\N	\N	新鲜直送农场	\N	2	1	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
6	3	1	EXP-WCH-001	4500.00	2026-03-16	\N	1	\N	\N	新鲜直送农场	\N	1	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
7	3	1	EXP-WCH-002	3100.00	2026-03-18	\N	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
8	3	2	EXP-WCH-003	750.00	2026-03-19	\N	1	\N	\N	港灯	\N	3	2	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
9	3	3	EXP-WCH-004	8800.00	2026-03-21	\N	1	\N	\N	3月上半月工资	\N	2	1	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
10	3	5	EXP-WCH-005	12000.00	2026-03-21	\N	1	\N	\N	3月租金	\N	2	1	1	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
11	1	1	EXP-7E8-20260318-01	5078.81	2026-03-18	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-18 13:01:00	2026-03-22 11:27:44	\N
12	1	1	EXP-7E8-20260318-02	2972.19	2026-03-18	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-18 20:57:00	2026-03-22 11:27:44	\N
13	1	1	EXP-7E8-20260318-03	1679.07	2026-03-18	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-18 16:31:00	2026-03-22 11:27:44	\N
14	1	4	EXP-7E8-20260318-04	250.14	2026-03-18	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-18 18:06:00	2026-03-22 11:27:44	\N
15	1	4	EXP-7E8-20260318-05	245.95	2026-03-18	消毒液、清洁工具	1	\N	\N	清洁用品	\N	3	2	1	\N	\N	2026-03-18 10:57:00	2026-03-22 11:27:44	\N
16	2	1	EXP-XWH-20260318-06	4513.86	2026-03-18	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-18 11:26:00	2026-03-22 11:27:44	\N
17	2	1	EXP-XWH-20260318-07	3175.65	2026-03-18	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-18 09:29:00	2026-03-22 11:27:44	\N
18	2	1	EXP-XWH-20260318-08	1335.68	2026-03-18	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-18 20:44:00	2026-03-22 11:27:44	\N
19	2	4	EXP-XWH-20260318-09	393.90	2026-03-18	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-18 09:00:00	2026-03-22 11:27:44	\N
20	2	4	EXP-XWH-20260318-10	273.63	2026-03-18	消毒液、清洁工具	1	\N	\N	清洁用品	\N	3	2	1	\N	\N	2026-03-18 16:43:00	2026-03-22 11:27:44	\N
21	3	1	EXP-WCH-20260318-11	5439.92	2026-03-18	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-18 10:08:00	2026-03-22 11:27:44	\N
22	3	1	EXP-WCH-20260318-12	2345.97	2026-03-18	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-18 14:38:00	2026-03-22 11:27:44	\N
23	3	1	EXP-WCH-20260318-13	1755.99	2026-03-18	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-18 11:50:00	2026-03-22 11:27:44	\N
24	3	4	EXP-WCH-20260318-14	324.79	2026-03-18	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-18 20:58:00	2026-03-22 11:27:44	\N
25	3	4	EXP-WCH-20260318-15	296.57	2026-03-18	消毒液、清洁工具	1	\N	\N	清洁用品	\N	3	2	1	\N	\N	2026-03-18 10:58:00	2026-03-22 11:27:45	\N
26	1	1	EXP-7E8-20260319-01	4270.62	2026-03-19	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-19 14:26:00	2026-03-22 11:27:45	\N
27	1	1	EXP-7E8-20260319-02	3084.83	2026-03-19	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-19 18:14:00	2026-03-22 11:27:45	\N
28	1	1	EXP-7E8-20260319-03	805.12	2026-03-19	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-19 17:22:00	2026-03-22 11:27:45	\N
29	1	4	EXP-7E8-20260319-04	299.93	2026-03-19	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-19 18:43:00	2026-03-22 11:27:45	\N
30	1	5	EXP-7E8-20260319-05	15000.00	2026-03-19	月租（月初一次性）	1	\N	\N	房东	\N	2	2	1	\N	\N	2026-03-19 09:07:00	2026-03-22 11:27:45	\N
31	2	1	EXP-XWH-20260319-06	5004.46	2026-03-19	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-19 12:13:00	2026-03-22 11:27:45	\N
32	2	1	EXP-XWH-20260319-07	2327.95	2026-03-19	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-19 12:20:00	2026-03-22 11:27:45	\N
33	2	1	EXP-XWH-20260319-08	846.64	2026-03-19	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-19 17:49:00	2026-03-22 11:27:45	\N
34	2	4	EXP-XWH-20260319-09	300.75	2026-03-19	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-19 10:11:00	2026-03-22 11:27:45	\N
35	2	5	EXP-XWH-20260319-10	18000.00	2026-03-19	月租（月初一次性）	1	\N	\N	房东	\N	2	2	1	\N	\N	2026-03-19 15:05:00	2026-03-22 11:27:45	\N
36	3	1	EXP-WCH-20260319-11	3366.66	2026-03-19	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-19 11:33:00	2026-03-22 11:27:45	\N
37	3	1	EXP-WCH-20260319-12	3078.95	2026-03-19	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-19 20:41:00	2026-03-22 11:27:45	\N
38	3	1	EXP-WCH-20260319-13	1048.91	2026-03-19	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-19 17:00:00	2026-03-22 11:27:45	\N
39	3	4	EXP-WCH-20260319-14	332.58	2026-03-19	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-19 14:44:00	2026-03-22 11:27:45	\N
40	3	5	EXP-WCH-20260319-15	28000.00	2026-03-19	月租（月初一次性）	1	\N	\N	房东	\N	2	2	1	\N	\N	2026-03-19 15:38:00	2026-03-22 11:27:45	\N
41	1	1	EXP-7E8-20260320-01	3735.16	2026-03-20	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-20 10:51:00	2026-03-22 11:27:45	\N
42	1	1	EXP-7E8-20260320-02	3101.91	2026-03-20	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-20 15:11:00	2026-03-22 11:27:45	\N
43	1	1	EXP-7E8-20260320-03	1725.21	2026-03-20	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-20 16:52:00	2026-03-22 11:27:45	\N
44	1	4	EXP-7E8-20260320-04	285.49	2026-03-20	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-20 14:15:00	2026-03-22 11:27:45	\N
45	1	3	EXP-7E8-20260320-05	935.99	2026-03-20	日结人工	1	\N	\N	员工工资	\N	2	2	1	\N	\N	2026-03-20 11:21:00	2026-03-22 11:27:45	\N
46	2	1	EXP-XWH-20260320-06	4842.45	2026-03-20	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-20 14:45:00	2026-03-22 11:27:45	\N
47	2	1	EXP-XWH-20260320-07	2592.01	2026-03-20	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-20 11:46:00	2026-03-22 11:27:45	\N
48	2	1	EXP-XWH-20260320-08	1241.44	2026-03-20	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-20 13:51:00	2026-03-22 11:27:45	\N
49	2	4	EXP-XWH-20260320-09	339.96	2026-03-20	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-20 12:06:00	2026-03-22 11:27:45	\N
50	2	3	EXP-XWH-20260320-10	1071.19	2026-03-20	日结人工	1	\N	\N	员工工资	\N	2	2	1	\N	\N	2026-03-20 12:03:00	2026-03-22 11:27:45	\N
51	3	1	EXP-WCH-20260320-11	3634.26	2026-03-20	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-20 20:04:00	2026-03-22 11:27:45	\N
52	3	1	EXP-WCH-20260320-12	2848.64	2026-03-20	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-20 17:07:00	2026-03-22 11:27:45	\N
53	3	1	EXP-WCH-20260320-13	1585.83	2026-03-20	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-20 08:26:00	2026-03-22 11:27:45	\N
54	3	4	EXP-WCH-20260320-14	371.34	2026-03-20	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-20 17:46:00	2026-03-22 11:27:45	\N
55	3	3	EXP-WCH-20260320-15	1065.81	2026-03-20	日结人工	1	\N	\N	员工工资	\N	2	2	1	\N	\N	2026-03-20 08:18:00	2026-03-22 11:27:45	\N
56	1	1	EXP-7E8-20260321-01	5010.79	2026-03-21	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-21 11:20:00	2026-03-22 11:27:45	\N
57	1	1	EXP-7E8-20260321-02	3156.77	2026-03-21	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-21 20:16:00	2026-03-22 11:27:45	\N
58	1	1	EXP-7E8-20260321-03	1202.42	2026-03-21	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-21 08:36:00	2026-03-22 11:27:45	\N
59	1	4	EXP-7E8-20260321-04	299.73	2026-03-21	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-21 08:15:00	2026-03-22 11:27:45	\N
60	1	2	EXP-7E8-20260321-05	87.78	2026-03-21	水费	1	\N	\N	水务署	\N	1	2	1	\N	\N	2026-03-21 15:06:00	2026-03-22 11:27:45	\N
61	2	1	EXP-XWH-20260321-06	4838.89	2026-03-21	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-21 09:26:00	2026-03-22 11:27:45	\N
62	2	1	EXP-XWH-20260321-07	2746.02	2026-03-21	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-21 19:29:00	2026-03-22 11:27:45	\N
63	2	1	EXP-XWH-20260321-08	1355.27	2026-03-21	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-21 09:29:00	2026-03-22 11:27:45	\N
64	2	4	EXP-XWH-20260321-09	152.14	2026-03-21	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-21 16:47:00	2026-03-22 11:27:45	\N
65	2	2	EXP-XWH-20260321-10	114.19	2026-03-21	水费	1	\N	\N	水务署	\N	1	2	1	\N	\N	2026-03-21 17:45:00	2026-03-22 11:27:45	\N
66	3	1	EXP-WCH-20260321-11	3920.74	2026-03-21	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	2	1	\N	\N	2026-03-21 13:06:00	2026-03-22 11:27:45	\N
67	3	1	EXP-WCH-20260321-12	2917.28	2026-03-21	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	2	1	\N	\N	2026-03-21 18:17:00	2026-03-22 11:27:45	\N
68	3	1	EXP-WCH-20260321-13	1002.04	2026-03-21	水产采购	1	\N	\N	南海水产行	\N	1	2	1	\N	\N	2026-03-21 13:00:00	2026-03-22 11:27:45	\N
69	3	4	EXP-WCH-20260321-14	217.97	2026-03-21	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	2	1	\N	\N	2026-03-21 17:47:00	2026-03-22 11:27:45	\N
70	3	2	EXP-WCH-20260321-15	97.08	2026-03-21	水费	1	\N	\N	水务署	\N	1	2	1	\N	\N	2026-03-21 08:53:00	2026-03-22 11:27:45	\N
71	1	1	EXP-7E8-20260322-01	3513.37	2026-03-22	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	1	1	\N	\N	2026-03-22 19:14:00	2026-03-22 11:27:45	\N
72	1	1	EXP-7E8-20260322-02	2845.70	2026-03-22	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	1	1	\N	\N	2026-03-22 13:00:00	2026-03-22 11:27:45	\N
73	1	1	EXP-7E8-20260322-03	1797.00	2026-03-22	水产采购	1	\N	\N	南海水产行	\N	1	1	1	\N	\N	2026-03-22 11:21:00	2026-03-22 11:27:45	\N
74	1	4	EXP-7E8-20260322-04	176.47	2026-03-22	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	1	1	\N	\N	2026-03-22 19:06:00	2026-03-22 11:27:45	\N
75	1	2	EXP-7E8-20260322-05	736.51	2026-03-22	电费	1	\N	\N	中华电力/港灯	\N	5	1	1	\N	\N	2026-03-22 18:21:00	2026-03-22 11:27:45	\N
76	2	1	EXP-XWH-20260322-06	3239.07	2026-03-22	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	1	1	\N	\N	2026-03-22 14:57:00	2026-03-22 11:27:45	\N
77	2	1	EXP-XWH-20260322-07	1837.90	2026-03-22	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	1	1	\N	\N	2026-03-22 19:58:00	2026-03-22 11:27:45	\N
78	2	1	EXP-XWH-20260322-08	1751.91	2026-03-22	水产采购	1	\N	\N	南海水产行	\N	1	1	1	\N	\N	2026-03-22 10:12:00	2026-03-22 11:27:45	\N
79	2	4	EXP-XWH-20260322-09	336.79	2026-03-22	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	1	1	\N	\N	2026-03-22 20:20:00	2026-03-22 11:27:45	\N
80	2	2	EXP-XWH-20260322-10	725.84	2026-03-22	电费	1	\N	\N	中华电力/港灯	\N	5	1	1	\N	\N	2026-03-22 15:35:00	2026-03-22 11:27:45	\N
81	3	1	EXP-WCH-20260322-11	3520.95	2026-03-22	蔬果采购	1	\N	\N	新鲜直送农场	\N	2	1	1	\N	\N	2026-03-22 10:32:00	2026-03-22 11:27:45	\N
82	3	1	EXP-WCH-20260322-12	2017.08	2026-03-22	肉类采购	1	\N	\N	港鲜肉类批发	\N	2	1	1	\N	\N	2026-03-22 09:31:00	2026-03-22 11:27:45	\N
83	3	1	EXP-WCH-20260322-13	891.96	2026-03-22	水产采购	1	\N	\N	南海水产行	\N	1	1	1	\N	\N	2026-03-22 08:01:00	2026-03-22 11:27:45	\N
84	3	4	EXP-WCH-20260322-14	332.23	2026-03-22	包装袋、托盘、保鲜膜	1	\N	\N	包装耗材	\N	3	1	1	\N	\N	2026-03-22 14:27:00	2026-03-22 11:27:45	\N
85	3	2	EXP-WCH-20260322-15	884.44	2026-03-22	电费	1	\N	\N	中华电力/港灯	\N	5	1	1	\N	\N	2026-03-22 17:43:00	2026-03-22 11:27:45	\N
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: industries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.industries (id, slug, name, emoji, title, description, sort_order, enabled, created_at, updated_at, api_base, api_token, ai_path, ai_media, greeting) FROM stdin;
11	cross_border	跨境电商	🌐	AI 跨境助手	文案/翻译/五点/侵权检测	92	t	2026-06-12 12:16:48	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 跨境助手 🌐\n\n点下面菜单或直接跟我说，我能帮你：\n🤖 AI 工具 · 翻译 / 文案 / 五点描述\n🔍 侵权检测 · 单词 / 品牌专利\n📊 经营查询 / 日常管理
1	fresh	生鲜门店	🥬	舌尖生鲜	果蔬肉禽 · 进货/库存/损耗/销售	20	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	t	我是舌尖生鲜 · AI 店长助手 🥬\n\n直接在下面输入框跟我说，我能帮你：\n📦 查库存 / 报剩余\n💰 录销售 / 查今日销售\n🚚 记进货\n🗑️ 记损耗
10	erp_crm	AI进销存及CRM	📊	进销存及CRM	商品/采购/销售/客户/线索/商机	8	t	2026-06-12 08:00:22	2026-06-14 16:35:39	https://app2.xingke888.com/api	ak_C1LJDcqx5NtuwETI3wulJg4VwIQA6P3NZrgSLoJ2pUULB8DP	\N	t	我是 AI 进销存 & CRM 助手 📊\n\n点下面菜单或直接跟我说，我能帮你：\n📦 商品 / 采购 / 销售\n👥 客户 / 线索 / 商机\n📊 经营数据查询
2	restaurant	餐饮快餐	🍜	AI 餐饮店长	点餐/营业额/备料/损耗	16	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 餐饮店长 🍜\n\n点下面菜单或直接跟我说，我能帮你：\n📈 营业概况 / 热销菜品\n🥬 备料建议 / 库存\n🗑️ 损耗登记\n👥 会员储值
3	apparel	服装零售	👕	AI 服装店长	上新/库存/销售/会员	30	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 服装店长 👕\n\n点下面菜单或直接跟我说，我能帮你：\n🆕 上新登记 / 款式管理\n📦 库存 / 尺码缺货\n💰 销售统计\n👥 会员管理
4	convenience	便利超市	🏪	AI 便利店长	进货/库存/销售/促销	40	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 便利店长 🏪\n\n点下面菜单或直接跟我说，我能帮你：\n🚚 进货登记 / 补货建议\n📦 库存 / 临期预警\n💰 销售统计\n🎁 促销活动
5	beauty	美业服务	💇	AI 美业管家	预约/会员/消费/员工	50	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 美业管家 💇\n\n点下面菜单或直接跟我说，我能帮你：\n📅 预约管理 / 客户回访\n👥 会员 / 办卡储值\n🧾 消费记录\n🏆 员工业绩
6	manufacturing	制造业	🏭	AI 生产助手	订单/产能/物料/排程	60	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 生产助手 🏭\n\n点下面菜单或直接跟我说，我能帮你：\n📐 工艺文档 · SOP / 参数 / 报价\n🔧 设备运维 · 故障诊断 / 保养\n🔍 质量管理 · 质检 / 8D / 根因\n🛡️ 安全精益 · 隐患排查 / 5S
12	auto_repair	汽修门店	🚗	AI 汽修助手	故障诊断/维修保养/报价工单	65	t	2026-06-14 15:57:35	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 汽修助手 🚗\n\n点下面菜单或直接跟我说，我能帮你：\n🩺 故障诊断 · 故障码 / 异响\n🔧 维修保养 · 方案 / 工时 / 配件\n💵 报价开单 · 报价单 / 工单\n🛎️ 客户服务 · 沟通 / 回访话术
7	insurance	保险	🛡️	AI 保险助手	保单/客户/续保/业绩	70	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 保险助手 🛡️\n\n点下面菜单或直接跟我说，我能帮你：\n📄 保单查询\n🤝 客户跟进 / 续保提醒\n🏆 业绩统计\n💼 理赔进度
8	finance	金融	💰	AI 金融助手	账户/对账/客户/风控	5	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 金融助手 💰\n\n点下面菜单或直接跟我说，我能帮你：\n📈 投研分析 · 财报 / 估值 / DCF\n🏦 投行交易 · 建模 / 路演 PPT\n💰 基金行政 · 对账 / NAV / 月末结账\n🌱 私募财富 · 寻源 / 组合分析
9	ecommerce	电商	🛒	AI 电商助手	订单/库存/退款/客服	12	t	2026-06-11 23:20:27	2026-06-14 16:35:39	\N	\N	\N	f	我是 AI 电商助手 🛒\n\n点下面菜单或直接跟我说，我能帮你：\n✍️ 写标题 / 详情 / 种草文案\n🎬 短视频 / 直播话术\n📈 关键词 / 竞品 / 活动策划\n🛎️ 客服 / 差评 / 售后话术
\.


--
-- Data for Name: intelligence_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.intelligence_reports (id, organization_id, store_id, report_period_start, report_period_end, report_type, price_gap_summary, hot_products_summary, ai_insights, action_recommendations, generated_at, is_auto_generated) FROM stdin;
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory (id, store_id, product_id, current_qty, available_qty, locked_qty, avg_cost, last_in_at, last_out_at, last_counted_at, updated_at, last_sold_at) FROM stdin;
22	3	1	10.000	10.000	0.000	1.2000	2026-03-20 09:07:00	2026-04-16 23:19:24	\N	2026-04-16 23:19:24	2026-04-16 23:19:24
23	3	2	35.000	35.000	0.000	3.5000	2026-03-20 09:02:06	\N	\N	2026-03-22 16:02:06	\N
24	3	3	0.000	0.000	0.000	0.8000	2026-03-20 09:18:00	2026-04-16 23:32:59	\N	2026-04-16 23:32:59	2026-04-16 23:14:36
25	3	4	123.600	123.600	0.000	2.5000	2026-03-20 09:43:00	\N	\N	2026-03-22 19:24:50	\N
26	3	5	28.000	28.000	0.000	2.8000	2026-03-21 03:02:06	\N	\N	2026-03-22 16:02:06	\N
27	3	6	96.100	96.100	0.000	1.0000	2026-03-20 09:56:00	\N	\N	2026-03-22 19:24:50	\N
28	3	7	0.000	0.000	0.000	1.5000	2026-03-20 09:01:00	2026-04-04 07:25:26	\N	2026-04-04 07:25:26	2026-04-04 07:25:26
29	3	8	70.000	70.000	0.000	4.5000	2026-03-21 05:02:06	\N	\N	2026-03-22 16:02:06	\N
30	3	9	41.200	41.200	0.000	3.2000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
31	3	10	67.800	67.800	0.000	3.8000	2026-03-19 09:10:00	\N	\N	2026-03-22 19:24:50	\N
32	3	11	61.700	61.700	0.000	18.0000	2026-03-20 09:45:00	\N	\N	2026-03-22 19:24:50	\N
33	3	12	55.900	55.900	0.000	12.5000	2026-03-20 09:57:00	\N	\N	2026-03-22 19:24:50	\N
34	3	13	8.000	8.000	0.000	55.0000	2026-03-20 17:02:06	\N	\N	2026-03-22 16:02:06	\N
35	3	14	25.600	25.600	0.000	22.0000	2026-03-19 09:19:00	\N	\N	2026-03-22 19:24:50	\N
36	3	15	41.000	41.000	0.000	28.0000	2026-03-20 09:42:00	\N	\N	2026-03-22 19:24:50	\N
37	3	16	12.000	12.000	0.000	65.0000	2026-03-21 03:02:06	\N	\N	2026-03-22 16:02:06	\N
38	3	17	38.400	38.400	0.000	12.0000	2026-03-18 09:19:00	\N	\N	2026-03-22 19:24:49	\N
39	3	18	109.300	109.300	0.000	2.5000	2026-03-20 09:33:00	\N	\N	2026-03-22 19:24:50	\N
40	3	19	42.700	42.700	0.000	1.8000	2026-03-18 09:17:00	\N	\N	2026-03-22 19:24:49	\N
41	3	20	150.000	150.000	0.000	2.2000	2026-03-21 10:02:06	\N	\N	2026-03-22 16:02:06	\N
42	3	21	8.000	8.000	0.000	68.0000	2026-03-22 03:02:06	\N	\N	2026-03-22 16:02:06	\N
43	1	1	120.000	120.000	0.000	0.0000	2026-05-31 07:32:04	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
44	1	3	70.000	70.000	0.000	0.0000	2026-03-20 09:22:00	2026-05-11 07:24:17	\N	2026-05-11 07:24:17	2026-04-27 22:26:23
46	1	6	112.800	112.800	0.000	0.0000	2026-03-20 09:37:00	\N	\N	2026-03-22 19:24:50	\N
47	1	11	33.200	33.200	0.000	0.0000	2026-03-20 09:58:00	\N	\N	2026-03-22 19:24:50	\N
48	1	12	28.600	28.600	0.000	0.0000	2026-03-20 09:58:00	\N	\N	2026-03-22 19:24:50	\N
49	1	15	22.500	22.500	0.000	0.0000	2026-03-20 09:27:00	\N	\N	2026-03-22 19:24:50	\N
50	1	18	61.200	61.200	0.000	0.0000	2026-03-20 09:40:00	\N	\N	2026-03-22 19:24:50	\N
51	1	19	18.700	18.700	0.000	0.0000	2026-03-18 09:03:00	\N	\N	2026-03-22 19:24:49	\N
52	1	17	11.700	11.700	0.000	0.0000	2026-03-18 09:39:00	\N	\N	2026-03-22 19:24:49	\N
53	1	10	0.000	0.000	0.000	0.0000	2026-05-11 07:21:55	2026-05-11 20:29:08	\N	2026-05-11 20:29:08	2026-05-11 20:29:08
54	1	14	7.100	7.100	0.000	0.0000	2026-03-19 09:51:00	\N	\N	2026-03-22 19:24:49	\N
55	1	7	19.800	19.800	0.000	0.0000	2026-03-20 09:18:00	\N	\N	2026-03-22 19:24:50	\N
56	1	9	11.900	11.900	0.000	0.0000	2026-03-20 09:15:00	2026-05-11 20:01:53	\N	2026-05-11 20:01:53	\N
130	2	32	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
131	2	33	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
132	2	34	2.000	2.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
133	2	9	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
134	2	35	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
135	2	36	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
136	2	37	2.000	2.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
137	2	38	2.000	2.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
138	2	39	2.000	2.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
139	2	40	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
140	2	41	0.500	0.500	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
141	2	42	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
142	2	43	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
143	2	44	1.000	1.000	0.000	0.0000	2026-04-01 08:46:12	\N	\N	2026-04-01 08:46:12	\N
144	2	24	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
145	2	25	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
146	2	26	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
147	2	27	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
148	2	28	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
149	2	29	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
150	2	30	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
151	2	31	1.000	1.000	0.000	0.0000	2026-04-01 08:47:55	\N	\N	2026-04-01 08:47:55	\N
152	2	4	40.000	40.000	0.000	0.0000	\N	2026-04-27 21:56:48	\N	2026-04-27 21:56:48	2026-04-27 21:56:48
153	2	1	30.000	30.000	0.000	0.0000	\N	2026-04-04 02:47:00	\N	2026-04-04 03:05:09	2026-04-04 02:47:00
154	2	2	30.000	30.000	0.000	0.0000	\N	\N	\N	2026-04-04 02:46:59	\N
155	2	3	0.000	0.000	0.000	0.0000	\N	2026-04-04 02:47:00	\N	2026-04-04 02:47:00	2026-04-04 02:47:00
156	3	47	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
157	3	48	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
158	3	49	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
159	3	50	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
160	3	51	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
161	3	52	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
162	3	53	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
163	3	54	2.000	2.000	0.000	0.0000	2026-04-04 08:09:48	\N	\N	2026-04-04 08:09:48	\N
164	3	55	0.000	0.000	0.000	0.0000	\N	\N	\N	2026-04-05 05:33:08	\N
165	3	56	72.000	72.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
166	3	33	38.000	38.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
167	3	35	19.000	19.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
168	3	37	36.000	36.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
169	3	57	20.000	20.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
170	3	58	20.000	20.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
171	3	41	10.000	10.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
172	3	59	0.000	0.000	0.000	0.0000	2026-04-07 01:10:59	2026-04-07 06:50:00	\N	2026-04-07 06:50:56	2026-04-07 06:50:00
173	3	45	20.000	20.000	0.000	0.0000	2026-04-07 01:10:59	\N	\N	2026-04-07 01:10:59	\N
174	1	60	2.000	2.000	0.000	0.0000	2026-04-16 12:17:46	\N	\N	2026-04-16 12:17:46	\N
176	1	61	1.000	1.000	0.000	0.0000	2026-04-16 12:17:46	\N	\N	2026-04-16 12:17:46	\N
177	1	45	1.000	1.000	0.000	0.0000	2026-04-16 12:17:46	\N	\N	2026-04-16 12:17:46	\N
178	1	43	1.000	1.000	0.000	0.0000	2026-04-16 12:17:46	\N	\N	2026-04-16 12:17:46	\N
179	1	32	1.000	1.000	0.000	0.0000	2026-04-16 12:17:46	\N	\N	2026-04-16 12:17:46	\N
180	1	62	0.000	0.000	0.000	0.0000	\N	\N	\N	2026-04-16 22:45:20	\N
181	1	63	0.000	0.000	0.000	0.0000	\N	\N	\N	2026-04-27 20:56:40	\N
182	1	38	0.000	0.000	0.000	0.0000	\N	2026-06-02 15:30:34	\N	2026-06-02 15:30:40	\N
185	1	64	30.000	30.000	0.000	0.0000	2026-05-11 20:00:58	\N	\N	2026-05-11 20:00:58	\N
186	1	37	1.000	1.000	0.000	0.0000	2026-05-11 21:04:51	2026-05-11 21:03:03	\N	2026-05-11 21:04:51	\N
187	1	65	0.000	0.000	0.000	0.0000	\N	2026-05-11 21:02:17	\N	2026-05-11 21:02:17	\N
188	1	66	0.000	0.000	0.000	0.0000	\N	2026-05-11 21:02:17	\N	2026-05-11 21:02:17	\N
189	1	2	0.000	0.000	0.000	0.0000	\N	2026-05-11 21:02:17	\N	2026-05-11 21:02:17	\N
190	1	67	0.000	0.000	0.000	0.0000	\N	2026-05-11 21:02:17	\N	2026-05-11 21:02:17	\N
192	1	69	0.000	0.000	0.000	0.0000	\N	2026-05-11 21:02:17	\N	2026-05-11 21:02:17	\N
193	1	70	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
194	1	71	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
195	1	50	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
196	1	72	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
197	1	73	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
198	1	74	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
199	1	75	2.000	2.000	0.000	0.0000	2026-05-11 21:04:20	\N	\N	2026-05-11 21:04:20	\N
201	1	77	1.000	1.000	0.000	0.0000	2026-05-11 21:04:51	\N	\N	2026-05-11 21:04:51	\N
202	1	78	2.000	2.000	0.000	0.0000	2026-05-11 21:04:51	2026-05-30 08:10:59	\N	2026-05-30 08:10:59	2026-05-30 08:10:59
203	1	79	2.000	2.000	0.000	0.0000	2026-05-11 21:04:51	\N	\N	2026-05-11 21:04:51	\N
204	2	80	6.000	6.000	0.000	0.0000	2026-05-11 21:35:31	\N	\N	2026-05-11 21:35:31	\N
205	2	81	5.000	5.000	0.000	0.0000	2026-05-11 21:35:31	\N	\N	2026-05-11 21:35:31	\N
206	2	82	8.000	8.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
207	2	83	5.000	5.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
208	2	84	8.000	8.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
209	2	85	12.000	12.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
210	2	86	6.000	6.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
211	2	87	15.000	15.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
212	2	88	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
213	2	89	5.000	5.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
214	2	90	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
215	2	91	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
216	2	92	20.000	20.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
217	2	93	5.000	5.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
218	2	94	6.000	6.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
219	2	95	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
220	2	96	6.000	6.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
221	2	97	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
222	2	98	8.000	8.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
223	2	99	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
224	2	100	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
225	2	101	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
226	2	102	6.000	6.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
227	2	103	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
228	2	104	5.000	5.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
229	2	105	22.000	22.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
230	2	106	2.000	2.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
231	2	107	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
232	2	108	7.000	7.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
233	2	109	3.000	3.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
234	2	110	8.000	8.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
235	2	111	6.000	6.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
236	2	112	7.000	7.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
237	2	113	5.000	5.000	0.000	0.0000	2026-05-11 21:38:53	\N	\N	2026-05-11 21:38:53	\N
238	2	114	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
239	2	115	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
240	2	116	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
241	2	117	7.000	7.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
242	2	118	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
243	2	119	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
244	2	120	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
245	2	121	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
246	2	122	4.000	4.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
247	2	123	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
248	2	124	10.000	10.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
249	2	125	4.000	4.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
250	2	126	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
251	2	127	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
252	2	128	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
253	2	129	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
254	2	130	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
255	2	131	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
256	2	132	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
257	2	133	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
258	2	134	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
259	2	135	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
260	2	136	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
261	2	137	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
262	2	138	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
263	2	139	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
264	2	140	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
265	2	141	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
266	2	142	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
267	2	143	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
200	1	76	0.000	0.000	0.000	0.0000	2026-05-11 21:04:51	2026-06-03 20:30:47	\N	2026-05-11 21:04:51	2026-06-03 20:30:47
191	1	68	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-05-11 21:02:17	2026-06-03 20:45:49
268	2	144	5.000	5.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
269	2	145	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
270	2	146	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
271	2	147	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
272	2	148	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
273	2	149	4.000	4.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
274	2	150	3.000	3.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
275	2	151	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
276	2	152	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
277	2	153	2.000	2.000	0.000	0.0000	2026-05-11 21:38:54	\N	\N	2026-05-11 21:38:54	\N
278	1	154	0.000	0.000	0.000	0.0000	\N	2026-05-31 05:05:02	\N	2026-05-31 05:05:10	\N
279	1	124	24.000	24.000	0.000	0.0000	2026-05-31 07:32:04	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
280	1	155	12.000	12.000	0.000	0.0000	2026-05-31 07:32:04	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
281	1	156	8.000	8.000	0.000	0.0000	2026-05-31 07:32:04	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
282	1	57	24.000	24.000	0.000	0.0000	2026-05-31 07:32:04	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
184	1	4	149.000	149.000	0.000	0.0000	2026-05-11 05:41:39	2026-06-03 20:12:56	\N	2026-05-11 05:41:39	\N
283	1	157	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
284	1	34	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
285	1	158	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
286	1	159	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
287	1	160	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
288	1	161	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
289	1	87	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
290	1	162	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
291	1	163	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
292	1	164	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
293	1	165	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
294	1	166	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
295	1	167	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
296	1	168	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
297	1	169	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
298	1	170	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
299	1	171	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
300	1	172	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
301	1	173	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
302	1	174	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
303	1	93	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
304	1	175	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
305	1	176	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
306	1	177	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
307	1	178	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
308	1	179	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
309	1	127	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
310	1	180	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
311	1	181	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
312	1	182	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
313	1	183	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
314	1	184	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
315	1	185	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
316	1	186	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
317	1	108	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
318	1	109	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
319	1	120	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
320	1	187	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
321	1	188	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
322	1	189	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
323	1	190	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
324	1	191	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
325	1	192	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
326	1	193	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
327	1	194	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
175	1	44	0.000	0.000	0.000	0.0000	2026-04-16 12:17:46	2026-06-03 20:45:49	\N	2026-04-16 12:17:46	2026-06-03 20:45:49
328	1	85	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
329	1	195	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
330	1	196	0.000	0.000	0.000	0.0000	\N	2026-06-03 20:45:49	\N	2026-06-03 20:45:50	2026-06-03 20:45:49
183	1	8	118.000	118.000	0.000	0.0000	2026-06-12 11:46:29	2026-05-31 06:08:33	\N	2026-05-31 07:32:04	2026-05-31 06:08:33
\.


--
-- Data for Name: inventory_daily_snapshots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_daily_snapshots (id, store_id, product_id, date, opening_qty, received_qty, sold_qty, damage_qty, adjustment_qty, closing_qty, created_at, updated_at, sold_out_at) FROM stdin;
47	2	32	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
48	2	33	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
49	2	34	2026-04-01	2.000	2.000	0.000	0.000	0.000	2.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
50	2	9	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
51	2	35	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
52	2	36	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
53	2	37	2026-04-01	2.000	2.000	0.000	0.000	0.000	2.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
54	2	38	2026-04-01	2.000	2.000	0.000	0.000	0.000	2.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
55	2	39	2026-04-01	2.000	2.000	0.000	0.000	0.000	2.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
56	2	40	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
57	2	41	2026-04-01	0.500	0.500	0.000	0.000	0.000	0.500	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
58	2	42	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
59	2	43	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
60	2	44	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
61	2	24	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
62	2	25	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
63	2	26	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
64	2	27	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
65	2	28	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
66	2	29	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
67	2	30	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
68	2	31	2026-04-01	1.000	1.000	0.000	0.000	0.000	1.000	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
69	2	4	2026-04-04	30.000	0.000	90.000	0.000	0.000	0.000	2026-04-04 02:44:59	2026-04-04 02:47:00	2026-04-04 02:44:59
70	2	1	2026-04-04	20.000	0.000	55.000	0.000	0.000	5.000	2026-04-04 02:44:59	2026-04-04 02:47:00	\N
71	2	3	2026-04-04	0.000	0.000	10.000	0.000	0.000	0.000	2026-04-04 02:47:00	2026-04-04 02:47:00	2026-04-04 02:47:00
72	3	1	2026-04-04	154.100	0.000	10.000	0.000	0.000	144.100	2026-04-04 06:42:19	2026-04-04 07:24:08	\N
73	3	2	2026-04-04	35.000	0.000	0.000	0.000	0.000	35.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
74	3	3	2026-04-04	223.900	0.000	0.000	0.000	0.000	223.900	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
75	3	4	2026-04-04	123.600	0.000	0.000	0.000	0.000	123.600	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
76	3	5	2026-04-04	28.000	0.000	0.000	0.000	0.000	28.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
77	3	6	2026-04-04	96.100	0.000	0.000	0.000	0.000	96.100	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
78	3	7	2026-04-04	66.600	0.000	66.600	0.000	0.000	0.000	2026-04-04 06:42:19	2026-04-04 07:25:26	2026-04-04 07:25:26
79	3	8	2026-04-04	70.000	0.000	0.000	0.000	0.000	70.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
80	3	9	2026-04-04	15.200	0.000	0.000	0.000	0.000	15.200	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
81	3	10	2026-04-04	67.800	0.000	0.000	0.000	0.000	67.800	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
82	3	11	2026-04-04	61.700	0.000	0.000	0.000	0.000	61.700	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
83	3	12	2026-04-04	55.900	0.000	0.000	0.000	0.000	55.900	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
84	3	13	2026-04-04	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
85	3	14	2026-04-04	25.600	0.000	0.000	0.000	0.000	25.600	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
86	3	15	2026-04-04	41.000	0.000	0.000	0.000	0.000	41.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
87	3	16	2026-04-04	12.000	0.000	0.000	0.000	0.000	12.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
88	3	17	2026-04-04	38.400	0.000	0.000	0.000	0.000	38.400	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
89	3	18	2026-04-04	109.300	0.000	0.000	0.000	0.000	109.300	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
90	3	19	2026-04-04	42.700	0.000	0.000	0.000	0.000	42.700	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
91	3	20	2026-04-04	150.000	0.000	0.000	0.000	0.000	150.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
92	3	21	2026-04-04	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
93	1	1	2026-04-04	100.000	0.000	0.000	0.000	0.000	100.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
94	1	3	2026-04-04	102.600	0.000	0.000	0.000	0.000	102.600	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
95	1	6	2026-04-04	112.800	0.000	0.000	0.000	0.000	112.800	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
96	1	11	2026-04-04	33.200	0.000	0.000	0.000	0.000	33.200	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
97	1	12	2026-04-04	28.600	0.000	0.000	0.000	0.000	28.600	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
98	1	15	2026-04-04	22.500	0.000	0.000	0.000	0.000	22.500	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
99	1	18	2026-04-04	61.200	0.000	0.000	0.000	0.000	61.200	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
100	1	19	2026-04-04	18.700	0.000	0.000	0.000	0.000	18.700	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
101	1	17	2026-04-04	11.700	0.000	0.000	0.000	0.000	11.700	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
102	1	10	2026-04-04	20.900	0.000	0.000	0.000	0.000	20.900	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
103	1	14	2026-04-04	7.100	0.000	0.000	0.000	0.000	7.100	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
104	1	7	2026-04-04	19.800	0.000	0.000	0.000	0.000	19.800	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
105	1	9	2026-04-04	13.900	0.000	0.000	0.000	0.000	13.900	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
106	2	32	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
107	2	33	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
108	2	34	2026-04-04	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
109	2	9	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
110	2	35	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
111	2	36	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
112	2	37	2026-04-04	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
113	2	38	2026-04-04	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
114	2	39	2026-04-04	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
115	2	40	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
116	2	41	2026-04-04	0.500	0.000	0.000	0.000	0.000	0.500	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
117	2	42	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
118	2	43	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
119	2	44	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
120	2	24	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
121	2	25	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
122	2	26	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
123	2	27	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
124	2	28	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
125	2	29	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
126	2	30	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
127	2	31	2026-04-04	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
128	2	2	2026-04-04	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 06:42:19	2026-04-04 06:42:19	\N
129	3	1	2026-03-31	154.100	0.000	0.000	0.000	0.000	154.100	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
130	3	2	2026-03-31	35.000	0.000	0.000	0.000	0.000	35.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
131	3	3	2026-03-31	223.900	0.000	0.000	0.000	0.000	223.900	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
132	3	4	2026-03-31	123.600	0.000	0.000	0.000	0.000	123.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
133	3	5	2026-03-31	28.000	0.000	0.000	0.000	0.000	28.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
134	3	6	2026-03-31	96.100	0.000	0.000	0.000	0.000	96.100	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
135	3	7	2026-03-31	66.600	0.000	0.000	0.000	0.000	66.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
136	3	8	2026-03-31	70.000	0.000	0.000	0.000	0.000	70.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
137	3	9	2026-03-31	15.200	0.000	0.000	0.000	0.000	15.200	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
138	3	10	2026-03-31	67.800	0.000	0.000	0.000	0.000	67.800	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
139	3	11	2026-03-31	61.700	0.000	0.000	0.000	0.000	61.700	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
140	3	12	2026-03-31	55.900	0.000	0.000	0.000	0.000	55.900	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
141	3	13	2026-03-31	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
142	3	14	2026-03-31	25.600	0.000	0.000	0.000	0.000	25.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
143	3	15	2026-03-31	41.000	0.000	0.000	0.000	0.000	41.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
144	3	16	2026-03-31	12.000	0.000	0.000	0.000	0.000	12.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
145	3	17	2026-03-31	38.400	0.000	0.000	0.000	0.000	38.400	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
146	3	18	2026-03-31	109.300	0.000	0.000	0.000	0.000	109.300	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
147	3	19	2026-03-31	42.700	0.000	0.000	0.000	0.000	42.700	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
148	3	20	2026-03-31	150.000	0.000	0.000	0.000	0.000	150.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
149	3	21	2026-03-31	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
150	1	1	2026-03-31	100.000	0.000	0.000	0.000	0.000	100.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
151	1	3	2026-03-31	102.600	0.000	0.000	0.000	0.000	102.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
152	1	6	2026-03-31	112.800	0.000	0.000	0.000	0.000	112.800	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
153	1	11	2026-03-31	33.200	0.000	0.000	0.000	0.000	33.200	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
154	1	12	2026-03-31	28.600	0.000	0.000	0.000	0.000	28.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
155	1	15	2026-03-31	22.500	0.000	0.000	0.000	0.000	22.500	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
156	1	18	2026-03-31	61.200	0.000	0.000	0.000	0.000	61.200	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
157	1	19	2026-03-31	18.700	0.000	0.000	0.000	0.000	18.700	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
158	1	17	2026-03-31	11.700	0.000	0.000	0.000	0.000	11.700	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
159	1	10	2026-03-31	20.900	0.000	0.000	0.000	0.000	20.900	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
160	1	14	2026-03-31	7.100	0.000	0.000	0.000	0.000	7.100	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
161	1	7	2026-03-31	19.800	0.000	0.000	0.000	0.000	19.800	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
162	1	9	2026-03-31	13.900	0.000	0.000	0.000	0.000	13.900	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
163	2	32	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
164	2	33	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
165	2	34	2026-03-31	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
166	2	9	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
167	2	35	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
168	2	36	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
169	2	37	2026-03-31	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
170	2	38	2026-03-31	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
171	2	39	2026-03-31	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
172	2	40	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
173	2	41	2026-03-31	0.500	0.000	0.000	0.000	0.000	0.500	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
174	2	42	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
175	2	43	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
176	2	44	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
177	2	24	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
178	2	25	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
179	2	26	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
180	2	27	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
181	2	28	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
182	2	29	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
183	2	30	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
184	2	31	2026-03-31	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
185	2	4	2026-03-31	50.000	0.000	0.000	0.000	0.000	50.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
186	2	1	2026-03-31	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
187	2	2	2026-03-31	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
188	2	3	2026-03-31	0.000	0.000	0.000	0.000	0.000	0.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
189	3	1	2026-04-01	154.100	0.000	0.000	0.000	0.000	154.100	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
190	3	2	2026-04-01	35.000	0.000	0.000	0.000	0.000	35.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
191	3	3	2026-04-01	223.900	0.000	0.000	0.000	0.000	223.900	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
192	3	4	2026-04-01	123.600	0.000	0.000	0.000	0.000	123.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
193	3	5	2026-04-01	28.000	0.000	0.000	0.000	0.000	28.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
194	3	6	2026-04-01	96.100	0.000	0.000	0.000	0.000	96.100	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
195	3	7	2026-04-01	66.600	0.000	0.000	0.000	0.000	66.600	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
196	3	8	2026-04-01	70.000	0.000	0.000	0.000	0.000	70.000	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
197	3	9	2026-04-01	15.200	0.000	0.000	0.000	0.000	15.200	2026-04-04 07:11:35	2026-04-04 07:11:35	\N
198	3	10	2026-04-01	67.800	0.000	0.000	0.000	0.000	67.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
199	3	11	2026-04-01	61.700	0.000	0.000	0.000	0.000	61.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
200	3	12	2026-04-01	55.900	0.000	0.000	0.000	0.000	55.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
201	3	13	2026-04-01	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
202	3	14	2026-04-01	25.600	0.000	0.000	0.000	0.000	25.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
203	3	15	2026-04-01	41.000	0.000	0.000	0.000	0.000	41.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
204	3	16	2026-04-01	12.000	0.000	0.000	0.000	0.000	12.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
205	3	17	2026-04-01	38.400	0.000	0.000	0.000	0.000	38.400	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
206	3	18	2026-04-01	109.300	0.000	0.000	0.000	0.000	109.300	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
207	3	19	2026-04-01	42.700	0.000	0.000	0.000	0.000	42.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
208	3	20	2026-04-01	150.000	0.000	0.000	0.000	0.000	150.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
209	3	21	2026-04-01	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
210	1	1	2026-04-01	100.000	0.000	0.000	0.000	0.000	100.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
211	1	3	2026-04-01	102.600	0.000	0.000	0.000	0.000	102.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
212	1	6	2026-04-01	112.800	0.000	0.000	0.000	0.000	112.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
213	1	11	2026-04-01	33.200	0.000	0.000	0.000	0.000	33.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
214	1	12	2026-04-01	28.600	0.000	0.000	0.000	0.000	28.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
215	1	15	2026-04-01	22.500	0.000	0.000	0.000	0.000	22.500	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
216	1	18	2026-04-01	61.200	0.000	0.000	0.000	0.000	61.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
217	1	19	2026-04-01	18.700	0.000	0.000	0.000	0.000	18.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
218	1	17	2026-04-01	11.700	0.000	0.000	0.000	0.000	11.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
219	1	10	2026-04-01	20.900	0.000	0.000	0.000	0.000	20.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
220	1	14	2026-04-01	7.100	0.000	0.000	0.000	0.000	7.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
221	1	7	2026-04-01	19.800	0.000	0.000	0.000	0.000	19.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
222	1	9	2026-04-01	13.900	0.000	0.000	0.000	0.000	13.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
223	2	4	2026-04-01	50.000	0.000	0.000	0.000	0.000	50.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
224	2	1	2026-04-01	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
225	2	2	2026-04-01	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
226	2	3	2026-04-01	0.000	0.000	0.000	0.000	0.000	0.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
227	3	1	2026-04-02	154.100	0.000	0.000	0.000	0.000	154.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
228	3	2	2026-04-02	35.000	0.000	0.000	0.000	0.000	35.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
229	3	3	2026-04-02	223.900	0.000	0.000	0.000	0.000	223.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
230	3	4	2026-04-02	123.600	0.000	0.000	0.000	0.000	123.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
231	3	5	2026-04-02	28.000	0.000	0.000	0.000	0.000	28.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
232	3	6	2026-04-02	96.100	0.000	0.000	0.000	0.000	96.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
233	3	7	2026-04-02	66.600	0.000	0.000	0.000	0.000	66.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
234	3	8	2026-04-02	70.000	0.000	0.000	0.000	0.000	70.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
235	3	9	2026-04-02	15.200	0.000	0.000	0.000	0.000	15.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
236	3	10	2026-04-02	67.800	0.000	0.000	0.000	0.000	67.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
237	3	11	2026-04-02	61.700	0.000	0.000	0.000	0.000	61.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
238	3	12	2026-04-02	55.900	0.000	0.000	0.000	0.000	55.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
239	3	13	2026-04-02	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
240	3	14	2026-04-02	25.600	0.000	0.000	0.000	0.000	25.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
241	3	15	2026-04-02	41.000	0.000	0.000	0.000	0.000	41.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
242	3	16	2026-04-02	12.000	0.000	0.000	0.000	0.000	12.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
243	3	17	2026-04-02	38.400	0.000	0.000	0.000	0.000	38.400	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
244	3	18	2026-04-02	109.300	0.000	0.000	0.000	0.000	109.300	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
245	3	19	2026-04-02	42.700	0.000	0.000	0.000	0.000	42.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
246	3	20	2026-04-02	150.000	0.000	0.000	0.000	0.000	150.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
247	3	21	2026-04-02	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
248	1	1	2026-04-02	100.000	0.000	0.000	0.000	0.000	100.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
249	1	3	2026-04-02	102.600	0.000	0.000	0.000	0.000	102.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
250	1	6	2026-04-02	112.800	0.000	0.000	0.000	0.000	112.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
251	1	11	2026-04-02	33.200	0.000	0.000	0.000	0.000	33.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
252	1	12	2026-04-02	28.600	0.000	0.000	0.000	0.000	28.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
253	1	15	2026-04-02	22.500	0.000	0.000	0.000	0.000	22.500	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
254	1	18	2026-04-02	61.200	0.000	0.000	0.000	0.000	61.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
255	1	19	2026-04-02	18.700	0.000	0.000	0.000	0.000	18.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
256	1	17	2026-04-02	11.700	0.000	0.000	0.000	0.000	11.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
257	1	10	2026-04-02	20.900	0.000	0.000	0.000	0.000	20.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
258	1	14	2026-04-02	7.100	0.000	0.000	0.000	0.000	7.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
259	1	7	2026-04-02	19.800	0.000	0.000	0.000	0.000	19.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
260	1	9	2026-04-02	13.900	0.000	0.000	0.000	0.000	13.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
261	2	32	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
262	2	33	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
263	2	34	2026-04-02	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
264	2	9	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
265	2	35	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
266	2	36	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
267	2	37	2026-04-02	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
268	2	38	2026-04-02	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
269	2	39	2026-04-02	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
270	2	40	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
271	2	41	2026-04-02	0.500	0.000	0.000	0.000	0.000	0.500	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
272	2	42	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
273	2	43	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
274	2	44	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
275	2	24	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
276	2	25	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
277	2	26	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
278	2	27	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
279	2	28	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
280	2	29	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
281	2	30	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
282	2	31	2026-04-02	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
283	2	4	2026-04-02	50.000	0.000	0.000	0.000	0.000	50.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
284	2	1	2026-04-02	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
285	2	2	2026-04-02	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
286	2	3	2026-04-02	0.000	0.000	0.000	0.000	0.000	0.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
287	3	1	2026-04-03	154.100	0.000	0.000	0.000	0.000	154.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
288	3	2	2026-04-03	35.000	0.000	0.000	0.000	0.000	35.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
289	3	3	2026-04-03	223.900	0.000	0.000	0.000	0.000	223.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
290	3	4	2026-04-03	123.600	0.000	0.000	0.000	0.000	123.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
291	3	5	2026-04-03	28.000	0.000	0.000	0.000	0.000	28.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
292	3	6	2026-04-03	96.100	0.000	0.000	0.000	0.000	96.100	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
293	3	7	2026-04-03	66.600	0.000	0.000	0.000	0.000	66.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
294	3	8	2026-04-03	70.000	0.000	0.000	0.000	0.000	70.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
295	3	9	2026-04-03	15.200	0.000	0.000	0.000	0.000	15.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
296	3	10	2026-04-03	67.800	0.000	0.000	0.000	0.000	67.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
297	3	11	2026-04-03	61.700	0.000	0.000	0.000	0.000	61.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
298	3	12	2026-04-03	55.900	0.000	0.000	0.000	0.000	55.900	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
299	3	13	2026-04-03	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
300	3	14	2026-04-03	25.600	0.000	0.000	0.000	0.000	25.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
301	3	15	2026-04-03	41.000	0.000	0.000	0.000	0.000	41.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
302	3	16	2026-04-03	12.000	0.000	0.000	0.000	0.000	12.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
303	3	17	2026-04-03	38.400	0.000	0.000	0.000	0.000	38.400	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
304	3	18	2026-04-03	109.300	0.000	0.000	0.000	0.000	109.300	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
305	3	19	2026-04-03	42.700	0.000	0.000	0.000	0.000	42.700	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
306	3	20	2026-04-03	150.000	0.000	0.000	0.000	0.000	150.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
307	3	21	2026-04-03	8.000	0.000	0.000	0.000	0.000	8.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
308	1	1	2026-04-03	100.000	0.000	0.000	0.000	0.000	100.000	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
309	1	3	2026-04-03	102.600	0.000	0.000	0.000	0.000	102.600	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
310	1	6	2026-04-03	112.800	0.000	0.000	0.000	0.000	112.800	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
311	1	11	2026-04-03	33.200	0.000	0.000	0.000	0.000	33.200	2026-04-04 07:11:36	2026-04-04 07:11:36	\N
312	1	12	2026-04-03	28.600	0.000	0.000	0.000	0.000	28.600	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
313	1	15	2026-04-03	22.500	0.000	0.000	0.000	0.000	22.500	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
314	1	18	2026-04-03	61.200	0.000	0.000	0.000	0.000	61.200	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
315	1	19	2026-04-03	18.700	0.000	0.000	0.000	0.000	18.700	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
316	1	17	2026-04-03	11.700	0.000	0.000	0.000	0.000	11.700	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
317	1	10	2026-04-03	20.900	0.000	0.000	0.000	0.000	20.900	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
318	1	14	2026-04-03	7.100	0.000	0.000	0.000	0.000	7.100	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
319	1	7	2026-04-03	19.800	0.000	0.000	0.000	0.000	19.800	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
320	1	9	2026-04-03	13.900	0.000	0.000	0.000	0.000	13.900	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
321	2	32	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
322	2	33	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
323	2	34	2026-04-03	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
324	2	9	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
325	2	35	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
326	2	36	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
327	2	37	2026-04-03	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
328	2	38	2026-04-03	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
329	2	39	2026-04-03	2.000	0.000	0.000	0.000	0.000	2.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
330	2	40	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
331	2	41	2026-04-03	0.500	0.000	0.000	0.000	0.000	0.500	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
332	2	42	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
333	2	43	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
334	2	44	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
335	2	24	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
336	2	25	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
337	2	26	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
338	2	27	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
339	2	28	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
340	2	29	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
341	2	30	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
342	2	31	2026-04-03	1.000	0.000	0.000	0.000	0.000	1.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
343	2	4	2026-04-03	50.000	0.000	0.000	0.000	0.000	50.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
344	2	1	2026-04-03	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
345	2	2	2026-04-03	30.000	0.000	0.000	0.000	0.000	30.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
346	2	3	2026-04-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-04-04 07:11:37	2026-04-04 07:11:37	\N
347	3	47	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
348	3	48	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
349	3	49	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
350	3	50	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
351	3	51	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
352	3	52	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
353	3	53	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
354	3	54	2026-04-04	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
355	3	56	2026-04-07	0.000	72.000	0.000	0.000	0.000	72.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
356	3	33	2026-04-07	0.000	38.000	0.000	0.000	0.000	38.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
357	3	9	2026-04-07	15.200	26.000	0.000	0.000	0.000	41.200	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
358	3	35	2026-04-07	0.000	19.000	0.000	0.000	0.000	19.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
359	3	37	2026-04-07	0.000	36.000	0.000	0.000	0.000	36.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
360	3	57	2026-04-07	0.000	20.000	0.000	0.000	0.000	20.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
361	3	58	2026-04-07	0.000	20.000	0.000	0.000	0.000	20.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
362	3	41	2026-04-07	0.000	10.000	0.000	0.000	0.000	10.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
363	3	59	2026-04-07	0.000	72.000	72.000	0.000	0.000	0.000	2026-04-07 01:10:59	2026-04-07 06:50:56	2026-04-07 06:50:00
364	3	45	2026-04-07	0.000	20.000	0.000	0.000	0.000	20.000	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
365	1	60	2026-04-16	0.000	2.000	0.000	0.000	0.000	2.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
366	1	44	2026-04-16	0.000	1.000	0.000	0.000	0.000	1.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
367	1	61	2026-04-16	0.000	1.000	0.000	0.000	0.000	1.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
368	1	45	2026-04-16	0.000	1.000	0.000	0.000	0.000	1.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
369	1	43	2026-04-16	0.000	1.000	0.000	0.000	0.000	1.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
370	1	32	2026-04-16	0.000	1.000	0.000	0.000	0.000	1.000	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
371	1	1	2026-04-16	100.000	0.000	100.000	0.000	0.000	0.000	2026-04-16 22:44:01	2026-04-16 22:44:01	2026-04-16 16:00:00
372	3	3	2026-04-16	223.900	0.000	223.900	10.000	0.000	0.000	2026-04-16 23:14:36	2026-04-16 23:32:59	2026-04-16 23:14:36
373	3	1	2026-04-16	144.100	0.000	134.100	0.000	0.000	10.000	2026-04-16 23:19:24	2026-04-16 23:19:24	\N
374	1	1	2026-04-27	0.000	0.000	20.000	0.000	0.000	0.000	2026-04-27 20:58:36	2026-04-27 21:28:45	2026-04-27 20:58:36
375	2	4	2026-04-27	50.000	0.000	10.000	0.000	0.000	40.000	2026-04-27 21:56:48	2026-04-27 21:56:48	\N
376	1	3	2026-04-27	102.600	0.000	22.600	0.000	0.000	80.000	2026-04-27 22:26:23	2026-04-27 22:26:23	\N
377	1	1	2026-04-28	0.000	20.000	0.000	0.000	0.000	20.000	2026-04-28 12:46:23	2026-04-28 12:46:23	\N
378	1	38	2026-04-28	0.000	0.000	0.000	0.500	0.000	0.000	2026-04-28 13:08:01	2026-04-28 13:08:01	2026-04-28 13:08:01
379	1	8	2026-04-28	0.000	0.000	0.000	0.000	0.000	20.000	2026-04-28 13:31:17	2026-04-28 13:31:17	\N
380	1	8	2026-04-29	20.000	0.000	20.000	0.000	0.000	0.000	2026-04-29 08:19:43	2026-04-29 08:19:43	2026-04-29 08:19:43
381	1	4	2026-05-11	0.000	150.000	0.000	0.000	0.000	150.000	2026-05-11 05:30:37	2026-05-11 05:41:39	\N
382	1	1	2026-05-11	20.000	100.000	0.000	0.000	0.000	120.000	2026-05-11 05:30:37	2026-05-11 20:00:58	\N
383	1	10	2026-05-11	20.900	10.000	30.900	0.000	0.000	0.000	2026-05-11 07:21:55	2026-05-11 20:29:08	2026-05-11 20:29:08
384	1	3	2026-05-11	80.000	0.000	0.000	10.000	0.000	70.000	2026-05-11 07:24:17	2026-05-11 07:24:17	\N
385	1	8	2026-05-11	0.000	0.000	0.000	2.000	0.000	0.000	2026-05-11 19:51:10	2026-05-11 19:51:22	2026-05-11 19:51:10
386	1	64	2026-05-11	0.000	30.000	0.000	0.000	0.000	30.000	2026-05-11 20:00:58	2026-05-11 20:00:58	\N
387	1	9	2026-05-11	13.900	0.000	0.000	2.000	0.000	11.900	2026-05-11 20:01:53	2026-05-11 20:01:53	\N
388	1	37	2026-05-11	0.000	1.000	0.000	2.505	0.000	1.000	2026-05-11 21:02:17	2026-05-11 21:04:51	\N
389	1	65	2026-05-11	0.000	0.000	0.000	1.000	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
390	1	66	2026-05-11	0.000	0.000	0.000	1.000	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
391	1	2	2026-05-11	0.000	0.000	0.000	2.274	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
392	1	67	2026-05-11	0.000	0.000	0.000	1.000	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
393	1	68	2026-05-11	0.000	0.000	0.000	5.982	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
394	1	69	2026-05-11	0.000	0.000	0.000	1.000	0.000	0.000	2026-05-11 21:02:17	2026-05-11 21:02:17	2026-05-11 21:02:17
395	1	70	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
396	1	71	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
397	1	50	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
398	1	72	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
399	1	73	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
400	1	74	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
401	1	75	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
402	1	76	2026-05-11	0.000	1.000	0.000	0.000	0.000	1.000	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
403	1	77	2026-05-11	0.000	1.000	0.000	0.000	0.000	1.000	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
404	1	78	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
405	1	79	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
406	2	80	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:35:31	2026-05-11 21:35:31	\N
407	2	81	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:35:31	2026-05-11 21:35:31	\N
408	2	82	2026-05-11	0.000	8.000	0.000	0.000	0.000	8.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
409	2	83	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
410	2	84	2026-05-11	0.000	8.000	0.000	0.000	0.000	8.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
411	2	85	2026-05-11	0.000	12.000	0.000	0.000	0.000	12.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
412	2	86	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
413	2	87	2026-05-11	0.000	15.000	0.000	0.000	0.000	15.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
414	2	88	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
415	2	89	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
416	2	90	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
417	2	91	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
418	2	92	2026-05-11	0.000	20.000	0.000	0.000	0.000	20.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
419	2	93	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
420	2	94	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
421	2	95	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
422	2	96	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
423	2	97	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
424	2	98	2026-05-11	0.000	8.000	0.000	0.000	0.000	8.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
425	2	99	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
426	2	100	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
427	2	101	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
428	2	102	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
429	2	103	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
430	2	104	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
431	2	105	2026-05-11	0.000	22.000	0.000	0.000	0.000	22.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
432	2	106	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
433	2	107	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
434	2	108	2026-05-11	0.000	7.000	0.000	0.000	0.000	7.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
435	2	109	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
436	2	110	2026-05-11	0.000	8.000	0.000	0.000	0.000	8.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
437	2	111	2026-05-11	0.000	6.000	0.000	0.000	0.000	6.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
438	2	112	2026-05-11	0.000	7.000	0.000	0.000	0.000	7.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
439	2	113	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
440	2	114	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
441	2	115	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
442	2	116	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
443	2	117	2026-05-11	0.000	7.000	0.000	0.000	0.000	7.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
444	2	118	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
445	2	119	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
446	2	120	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
447	2	121	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
448	2	122	2026-05-11	0.000	4.000	0.000	0.000	0.000	4.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
449	2	123	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
450	2	124	2026-05-11	0.000	10.000	0.000	0.000	0.000	10.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
451	2	125	2026-05-11	0.000	4.000	0.000	0.000	0.000	4.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
452	2	126	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
453	2	127	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
454	2	128	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
455	2	129	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
456	2	130	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
457	2	131	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
458	2	132	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
459	2	133	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
460	2	134	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
461	2	135	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
462	2	136	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
463	2	137	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
464	2	138	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
465	2	139	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
466	2	140	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
467	2	141	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
468	2	142	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
469	2	143	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
470	2	144	2026-05-11	0.000	5.000	0.000	0.000	0.000	5.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
471	2	145	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
472	2	146	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
473	2	147	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
474	2	148	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
475	2	149	2026-05-11	0.000	4.000	0.000	0.000	0.000	4.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
476	2	150	2026-05-11	0.000	3.000	0.000	0.000	0.000	3.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
477	2	151	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
478	2	152	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
479	2	153	2026-05-11	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
480	1	78	2026-05-30	3.000	0.000	1.000	0.000	0.000	2.000	2026-05-30 08:10:59	2026-05-30 08:10:59	\N
481	1	8	2026-05-30	0.000	2.000	0.000	0.000	0.000	2.000	2026-05-30 16:06:30	2026-05-30 16:06:30	\N
482	1	38	2026-05-30	0.000	0.000	0.000	2.000	0.000	0.000	2026-05-30 21:55:05	2026-05-30 21:55:05	2026-05-30 21:55:05
483	1	8	2026-05-31	2.000	18.000	0.000	2.000	0.000	18.000	2026-05-31 04:51:59	2026-05-31 07:32:04	\N
484	1	154	2026-05-31	0.000	0.000	0.000	0.000	0.000	0.000	2026-05-31 05:05:10	2026-05-31 05:05:10	2026-05-31 05:05:02
485	1	124	2026-05-31	0.000	24.000	0.000	0.000	0.000	24.000	2026-05-31 06:08:33	2026-05-31 07:32:04	\N
486	1	1	2026-05-31	120.000	32.000	32.000	0.000	0.000	120.000	2026-05-31 06:08:33	2026-05-31 07:32:04	\N
487	1	155	2026-05-31	0.000	12.000	0.000	0.000	0.000	12.000	2026-05-31 06:08:33	2026-05-31 07:32:04	\N
488	1	156	2026-05-31	0.000	8.000	0.000	0.000	0.000	8.000	2026-05-31 06:08:34	2026-05-31 07:32:04	\N
489	1	57	2026-05-31	0.000	24.000	0.000	0.000	0.000	24.000	2026-05-31 06:08:34	2026-05-31 07:32:04	\N
490	1	38	2026-06-02	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-02 15:30:40	2026-06-02 15:30:40	2026-06-02 15:30:34
491	1	4	2026-06-03	150.000	0.000	0.000	1.000	0.000	149.000	2026-06-03 20:13:08	2026-06-03 20:13:08	\N
492	1	76	2026-06-03	1.000	0.000	1.000	0.000	0.000	0.000	2026-06-03 20:30:47	2026-06-03 20:30:47	2026-06-03 20:30:47
493	1	157	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
494	1	34	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
495	1	158	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
496	1	159	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
497	1	160	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
498	1	161	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
499	1	87	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
500	1	162	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
501	1	163	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
502	1	164	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
503	1	165	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
504	1	166	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
505	1	167	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
506	1	168	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
507	1	169	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
508	1	170	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
509	1	171	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
510	1	172	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
511	1	173	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
512	1	174	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
513	1	93	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
514	1	175	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
515	1	176	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
516	1	177	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
517	1	178	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
518	1	179	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
519	1	127	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
520	1	180	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
521	1	181	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
522	1	182	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
523	1	183	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
524	1	184	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
525	1	185	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
526	1	186	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
527	1	108	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
528	1	109	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
529	1	120	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
530	1	187	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
531	1	68	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
532	1	188	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
533	1	189	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
534	1	190	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
535	1	191	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
536	1	192	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
537	1	193	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
538	1	194	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
539	1	44	2026-06-03	1.000	0.000	1.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
540	1	85	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
541	1	195	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
542	1	196	2026-06-03	0.000	0.000	0.000	0.000	0.000	0.000	2026-06-03 20:45:49	2026-06-03 20:45:49	2026-06-03 20:45:49
543	1	8	2026-06-12	18.000	100.000	0.000	0.000	0.000	118.000	2026-06-12 11:46:29	2026-06-12 11:46:29	\N
\.


--
-- Data for Name: inventory_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.inventory_transactions (id, store_id, product_id, transaction_type, qty_change, qty_before, qty_after, unit_cost, total_cost, reference_type, reference_id, batch_no, expiry_date, operator_id, notes, created_at) FROM stdin;
22	3	1	1	60.000	0.000	60.000	1.2000	72.00	seed	\N	\N	\N	1	演示初始库存	2026-03-22 06:02:06
23	3	2	1	35.000	0.000	35.000	3.5000	122.50	seed	\N	\N	\N	1	演示初始库存	2026-03-20 22:02:06
24	3	3	1	90.000	0.000	90.000	0.8000	72.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 02:02:06
25	3	4	1	45.000	0.000	45.000	2.5000	112.50	seed	\N	\N	\N	1	演示初始库存	2026-03-20 17:02:06
26	3	5	1	28.000	0.000	28.000	2.8000	78.40	seed	\N	\N	\N	1	演示初始库存	2026-03-21 07:02:06
27	3	6	1	5.000	0.000	5.000	1.0000	5.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 23:02:06
28	3	7	1	50.000	0.000	50.000	1.5000	75.00	seed	\N	\N	\N	1	演示初始库存	2026-03-20 09:02:06
29	3	8	1	70.000	0.000	70.000	4.5000	315.00	seed	\N	\N	\N	1	演示初始库存	2026-03-20 17:02:06
30	3	9	1	3.000	0.000	3.000	3.2000	9.60	seed	\N	\N	\N	1	演示初始库存	2026-03-21 18:02:06
31	3	10	1	55.000	0.000	55.000	3.8000	209.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 09:02:06
32	3	11	1	30.000	0.000	30.000	18.0000	540.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 17:02:06
33	3	12	1	22.000	0.000	22.000	12.5000	275.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 16:02:06
34	3	13	1	8.000	0.000	8.000	55.0000	440.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 02:02:06
35	3	14	1	18.000	0.000	18.000	22.0000	396.00	seed	\N	\N	\N	1	演示初始库存	2026-03-22 04:02:06
36	3	15	1	15.000	0.000	15.000	28.0000	420.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 20:02:06
37	3	16	1	12.000	0.000	12.000	65.0000	780.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 16:02:06
38	3	17	1	25.000	0.000	25.000	12.0000	300.00	seed	\N	\N	\N	1	演示初始库存	2026-03-20 20:02:06
39	3	18	1	40.000	0.000	40.000	2.5000	100.00	seed	\N	\N	\N	1	演示初始库存	2026-03-20 14:02:06
40	3	19	1	18.000	0.000	18.000	1.8000	32.40	seed	\N	\N	\N	1	演示初始库存	2026-03-20 08:02:06
41	3	20	1	150.000	0.000	150.000	2.2000	330.00	seed	\N	\N	\N	1	演示初始库存	2026-03-21 06:02:06
42	3	21	1	8.000	0.000	8.000	68.0000	544.00	seed	\N	\N	\N	1	演示初始库存	2026-03-22 01:02:06
43	1	1	1	26.200	0.000	26.200	1.2000	31.44	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:50:00
44	1	3	1	43.700	0.000	43.700	0.8000	34.96	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:23:00
45	1	4	1	22.800	0.000	22.800	2.5000	57.00	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:48:00
46	1	6	1	33.700	0.000	33.700	1.0000	33.70	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:10:00
47	1	11	1	11.500	0.000	11.500	18.0000	207.00	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:38:00
48	1	12	1	9.300	0.000	9.300	12.5000	116.25	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:00:00
49	1	15	1	6.500	0.000	6.500	28.0000	182.00	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:19:00
50	1	18	1	16.900	0.000	16.900	2.5000	42.25	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:33:00
51	1	19	1	18.700	0.000	18.700	1.8000	33.66	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:03:00
52	1	17	1	11.700	0.000	11.700	12.0000	140.40	purchase_order	1	\N	\N	1	进货单 PO-20260318-00001	2026-03-18 09:39:00
63	3	1	1	34.700	60.000	94.700	1.2000	41.64	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:31:00
64	3	3	1	44.500	90.000	134.500	0.8000	35.60	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:44:00
65	3	4	1	28.900	45.000	73.900	2.5000	72.25	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:26:00
66	3	6	1	37.200	5.000	42.200	1.0000	37.20	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:03:00
67	3	11	1	10.600	30.000	40.600	18.0000	190.80	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:21:00
68	3	12	1	8.700	22.000	30.700	12.5000	108.75	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:29:00
69	3	15	1	9.800	15.000	24.800	28.0000	274.40	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:22:00
70	3	18	1	25.700	40.000	65.700	2.5000	64.25	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:58:00
71	3	19	1	24.700	18.000	42.700	1.8000	44.46	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:17:00
72	3	17	1	13.400	25.000	38.400	12.0000	160.80	purchase_order	3	\N	\N	1	进货单 PO-20260318-00003	2026-03-18 09:19:00
73	1	1	1	37.400	26.200	63.600	1.2000	44.88	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:10:00
74	1	3	1	28.300	43.700	72.000	0.8000	22.64	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:55:00
75	1	4	1	20.800	22.800	43.600	2.5000	52.00	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:20:00
76	1	6	1	37.300	33.700	71.000	1.0000	37.30	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:24:00
77	1	11	1	12.100	11.500	23.600	18.0000	217.80	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:03:00
78	1	12	1	9.000	9.300	18.300	12.5000	112.50	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:15:00
79	1	15	1	7.200	6.500	13.700	28.0000	201.60	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:15:00
80	1	18	1	19.800	16.900	36.700	2.5000	49.50	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:09:00
81	1	10	1	20.900	0.000	20.900	3.8000	79.42	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:17:00
82	1	14	1	7.100	0.000	7.100	22.0000	156.20	purchase_order	4	\N	\N	1	进货单 PO-20260319-00001	2026-03-19 09:51:00
93	3	1	1	22.700	94.700	117.400	1.2000	27.24	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:42:00
94	3	3	1	48.900	134.500	183.400	0.8000	39.12	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:55:00
95	3	4	1	18.000	73.900	91.900	2.5000	45.00	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:08:00
96	3	6	1	27.200	42.200	69.400	1.0000	27.20	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:19:00
97	3	11	1	13.000	40.600	53.600	18.0000	234.00	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:48:00
98	3	12	1	12.200	30.700	42.900	12.5000	152.50	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:52:00
99	3	15	1	10.400	24.800	35.200	28.0000	291.20	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:36:00
100	3	18	1	22.600	65.700	88.300	2.5000	56.50	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:51:00
101	3	10	1	12.800	55.000	67.800	3.8000	48.64	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:10:00
102	3	14	1	7.600	18.000	25.600	22.0000	167.20	purchase_order	6	\N	\N	1	进货单 PO-20260319-00003	2026-03-19 09:19:00
103	1	1	1	32.500	63.600	96.100	1.2000	39.00	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:04:00
104	1	3	1	37.600	72.000	109.600	0.8000	30.08	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:22:00
105	1	4	1	21.700	43.600	65.300	2.5000	54.25	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:42:00
106	1	6	1	41.800	71.000	112.800	1.0000	41.80	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:37:00
107	1	11	1	9.600	23.600	33.200	18.0000	172.80	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:58:00
108	1	12	1	10.300	18.300	28.600	12.5000	128.75	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:58:00
109	1	15	1	8.800	13.700	22.500	28.0000	246.40	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:27:00
110	1	18	1	24.500	36.700	61.200	2.5000	61.25	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:40:00
111	1	7	1	19.800	0.000	19.800	1.5000	29.70	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:18:00
112	1	9	1	13.900	0.000	13.900	3.2000	44.48	purchase_order	7	\N	\N	1	进货单 PO-20260320-00001	2026-03-20 09:15:00
123	3	1	1	36.700	117.400	154.100	1.2000	44.04	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:07:00
124	3	3	1	40.500	183.400	223.900	0.8000	32.40	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:18:00
125	3	4	1	31.700	91.900	123.600	2.5000	79.25	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:43:00
126	3	6	1	26.700	69.400	96.100	1.0000	26.70	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:56:00
127	3	11	1	8.100	53.600	61.700	18.0000	145.80	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:45:00
128	3	12	1	13.000	42.900	55.900	12.5000	162.50	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:57:00
129	3	15	1	5.800	35.200	41.000	28.0000	162.40	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:42:00
130	3	18	1	21.000	88.300	109.300	2.5000	52.50	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:33:00
131	3	7	1	16.600	50.000	66.600	1.5000	24.90	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:01:00
132	3	9	1	12.200	3.000	15.200	3.2000	39.04	purchase_order	9	\N	\N	1	进货单 PO-20260320-00003	2026-03-20 09:50:00
133	1	8	1	50.000	0.000	50.000	\N	\N	\N	\N	\N	\N	8	苹果 50斤 AI录入	2026-03-31 04:23:28
134	1	8	2	-50.000	50.000	0.000	\N	\N	\N	\N	\N	\N	8	测试售罄	2026-03-31 05:21:29
135	1	1	2	-2.000	96.100	94.100	\N	\N	sales_order	3	\N	\N	\N	零售 SO-20260331-KMSOZX	2026-03-31 05:21:38
136	1	1	4	5.900	94.100	100.000	\N	\N	\N	\N	\N	\N	8	盘点修正测试	2026-03-31 05:22:10
137	1	3	3	-5.000	109.600	104.600	\N	\N	\N	\N	\N	\N	8	腐烂损耗	2026-03-31 05:22:10
138	1	3	3	-2.000	104.600	102.600	\N	\N	\N	\N	\N	\N	8	腐烂测试	2026-03-31 05:27:01
139	1	4	2	-65.300	65.300	0.000	\N	\N	\N	\N	\N	\N	8	售罄测试	2026-03-31 05:27:01
346	2	32	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
347	2	33	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
348	2	34	1	2.000	0.000	2.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
349	2	9	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
350	2	35	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
351	2	36	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
352	2	37	1	2.000	0.000	2.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
353	2	38	1	2.000	0.000	2.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
354	2	39	1	2.000	0.000	2.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
355	2	40	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
356	2	41	1	0.500	0.000	0.500	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
357	2	42	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
358	2	43	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
359	2	44	1	1.000	0.000	1.000	\N	\N	purchase_order	41	\N	\N	9	进货单 PO-20260401-00001	2026-04-01 08:46:12
360	2	24	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
361	2	25	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
362	2	26	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
363	2	27	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
364	2	28	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
365	2	29	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
366	2	30	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
367	2	31	1	1.000	0.000	1.000	\N	\N	purchase_order	42	\N	\N	9	进货单 PO-20260401-00002	2026-04-01 08:47:55
368	2	4	2	-30.000	30.000	0.000	8.5000	\N	\N	\N	\N	\N	1	远程补录售罄	2026-04-04 02:44:59
369	2	1	2	-15.000	20.000	5.000	3.5000	\N	\N	\N	\N	\N	1	远程补录售罄	2026-04-04 02:44:59
370	2	4	2	-30.000	30.000	0.000	8.5000	\N	\N	\N	\N	\N	1	远程补录售罄	2026-04-04 02:45:37
371	2	1	2	-15.000	20.000	5.000	3.5000	\N	\N	\N	\N	\N	1	远程补录售罄	2026-04-04 02:45:37
372	2	4	2	-30.000	30.000	0.000	8.5000	\N	\N	\N	\N	\N	1	远程补录销售	2026-04-04 02:47:00
373	2	1	2	-25.000	30.000	5.000	3.5000	\N	\N	\N	\N	\N	1	远程补录销售	2026-04-04 02:47:00
374	2	3	2	-10.000	0.000	0.000	2.0000	\N	\N	\N	\N	\N	1	远程补录销售	2026-04-04 02:47:00
375	3	1	2	-10.000	154.100	144.100	\N	\N	\N	\N	\N	\N	11	远程补录销售	2026-04-04 07:24:08
376	3	7	2	-66.600	66.600	0.000	\N	\N	\N	\N	\N	\N	11	远程补录销售	2026-04-04 07:25:26
377	3	47	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
378	3	48	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
379	3	49	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
380	3	50	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
381	3	51	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
382	3	52	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
383	3	53	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
384	3	54	1	2.000	0.000	2.000	\N	\N	purchase_order	43	\N	\N	11	进货单 PO-20260404-00001	2026-04-04 08:09:48
385	3	56	1	72.000	0.000	72.000	5.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
386	3	33	1	38.000	0.000	38.000	9.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
387	3	9	1	26.000	15.200	41.200	6.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
388	3	35	1	19.000	0.000	19.000	8.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
389	3	37	1	36.000	0.000	36.000	15.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
390	3	57	1	20.000	0.000	20.000	45.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
391	3	58	1	20.000	0.000	20.000	12.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
392	3	41	1	10.000	0.000	10.000	10.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
393	3	59	1	72.000	0.000	72.000	5.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
394	3	45	1	20.000	0.000	20.000	10.0000	\N	purchase_order	44	\N	\N	11	进货单 PO-20260407-00001	2026-04-07 01:10:59
395	3	59	2	-72.000	72.000	0.000	\N	\N	\N	\N	\N	\N	11	远程补录销售	2026-04-07 06:50:00
396	1	60	1	2.000	0.000	2.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
397	1	44	1	1.000	0.000	1.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
398	1	61	1	1.000	0.000	1.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
399	1	45	1	1.000	0.000	1.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
400	1	43	1	1.000	0.000	1.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
401	1	32	1	1.000	0.000	1.000	\N	\N	purchase_order	45	\N	\N	10	进货单 PO-20260416-00001	2026-04-16 12:17:46
402	1	1	2	-100.000	100.000	0.000	\N	\N	\N	\N	\N	\N	5	远程补录销售	2026-04-16 16:00:00
403	3	3	2	-223.900	223.900	0.000	\N	\N	\N	\N	\N	\N	11	远程补录销售	2026-04-16 23:14:36
404	3	1	2	-134.100	144.100	10.000	\N	\N	\N	\N	\N	\N	11	远程补录销售	2026-04-16 23:19:24
405	3	3	3	-10.000	0.000	0.000	\N	\N	\N	\N	\N	\N	11	白菜损耗	2026-04-16 23:32:59
406	1	1	2	-10.000	0.000	0.000	\N	\N	ai_message	35	\N	\N	12	胡萝卜 10斤 AI录入	2026-04-27 20:58:36
407	1	1	2	-10.000	0.000	0.000	\N	\N	ai_message	37	\N	\N	12	胡萝卜 10斤 AI录入	2026-04-27 21:28:45
408	2	4	2	-10.000	50.000	40.000	\N	\N	ai_message	39	\N	\N	1	番茄 10斤 AI录入	2026-04-27 21:56:48
409	1	3	2	-22.600	102.600	80.000	\N	\N	ai_message	47	\N	\N	12	白菜 22.6斤 AI录入	2026-04-27 22:26:23
410	1	1	1	20.000	0.000	20.000	\N	\N	purchase_order	46	\N	\N	13	进货单 PO-20260428-00001	2026-04-28 12:46:23
411	1	38	3	-0.500	0.000	0.000	\N	\N	ai_message	51	\N	\N	13	草莓 0.5斤 AI录入	2026-04-28 13:08:01
412	1	8	2	0.000	0.000	20.000	\N	\N	ai_message	55	\N	\N	13	苹果 20斤 AI录入	2026-04-28 13:31:17
413	1	8	2	-20.000	20.000	0.000	\N	\N	ai_message	59	\N	\N	12	苹果 AI标记售罄	2026-04-29 08:19:43
414	1	4	1	50.000	0.000	50.000	\N	\N	ai_message	61	\N	\N	12	番茄 50斤 AI录入	2026-05-11 05:30:37
415	1	1	1	30.000	20.000	50.000	\N	\N	ai_message	61	\N	\N	12	胡萝卜 30斤 AI录入	2026-05-11 05:30:37
416	1	4	1	50.000	50.000	100.000	\N	\N	ai_message	67	\N	\N	12	番茄 50斤 AI录入	2026-05-11 05:36:12
417	1	1	1	30.000	50.000	80.000	\N	\N	ai_message	67	\N	\N	12	胡萝卜 30斤 AI录入	2026-05-11 05:36:12
418	1	4	1	50.000	100.000	150.000	\N	\N	purchase_order	47	\N	\N	12	番茄 50斤 AI录入	2026-05-11 05:41:39
419	1	1	1	30.000	80.000	110.000	\N	\N	purchase_order	47	\N	\N	12	胡萝卜 30斤 AI录入	2026-05-11 05:41:39
420	1	10	1	10.000	20.900	30.900	\N	\N	purchase_order	48	\N	\N	12	橙子 10斤 AI录入	2026-05-11 07:21:55
421	1	3	3	-10.000	80.000	70.000	\N	\N	ai_message	81	\N	\N	12	白菜 10斤 AI录入	2026-05-11 07:24:17
422	1	8	3	-1.000	0.000	0.000	\N	\N	ai_message	85	\N	\N	12	苹果 1斤 AI录入	2026-05-11 19:51:10
423	1	8	3	-1.000	0.000	0.000	\N	\N	ai_message	87	\N	\N	12	苹果 1斤 AI录入	2026-05-11 19:51:22
424	1	1	1	10.000	110.000	120.000	\N	\N	purchase_order	49	\N	\N	13	胡萝卜 10斤 AI录入	2026-05-11 20:00:58
425	1	64	1	30.000	0.000	30.000	\N	\N	purchase_order	49	\N	\N	13	猕猴桃 30斤 AI录入	2026-05-11 20:00:58
426	1	9	3	-2.000	13.900	11.900	\N	\N	ai_message	91	\N	\N	13	香蕉 2斤 AI录入	2026-05-11 20:01:53
427	1	8	2	0.000	0.000	0.000	\N	\N	ai_message	93	\N	\N	12	苹果 AI标记售罄	2026-05-11 20:28:44
428	1	10	2	-30.900	30.900	0.000	\N	\N	ai_message	95	\N	\N	12	橙子 AI标记售罄	2026-05-11 20:29:08
429	1	37	3	-1.095	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	枇杷 1.095斤 AI录入	2026-05-11 21:02:17
430	1	65	3	-1.000	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	辣椒叶300g 1袋 AI录入	2026-05-11 21:02:17
431	1	66	3	-1.000	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	地瓜叶300g 1袋 AI录入	2026-05-11 21:02:17
432	1	2	3	-2.274	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	西兰花 2.274斤 AI录入	2026-05-11 21:02:17
433	1	67	3	-1.000	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	黄豆芽300g 1袋 AI录入	2026-05-11 21:02:17
434	1	68	3	-5.982	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	番茄(粉)350g 5.982袋 AI录入	2026-05-11 21:02:17
435	1	69	3	-1.000	0.000	0.000	\N	\N	ai_message	97	\N	\N	12	玉露香梨 1个 AI录入	2026-05-11 21:02:17
436	1	37	3	-1.410	0.000	0.000	\N	\N	ai_message	99	\N	\N	12	枇杷 1.41斤 AI录入	2026-05-11 21:03:03
437	1	70	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	上海麵350g 2盒 AI录入	2026-05-11 21:04:20
438	1	71	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	蝦米腸粉 2盒 AI录入	2026-05-11 21:04:20
439	1	50	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	白腸粉 2盒 AI录入	2026-05-11 21:04:20
440	1	72	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	油麵350g 2盒 AI录入	2026-05-11 21:04:20
441	1	73	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	雲吞麵 (幼) 350g 2盒 AI录入	2026-05-11 21:04:20
442	1	74	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	雲吞麵 (粗) 350g 2盒 AI录入	2026-05-11 21:04:20
443	1	75	1	2.000	0.000	2.000	\N	\N	purchase_order	50	\N	\N	12	河粉 (炒粉) 350g 2盒 AI录入	2026-05-11 21:04:20
444	1	76	1	1.000	0.000	1.000	\N	\N	purchase_order	51	\N	\N	12	牛油果 1件 AI录入	2026-05-11 21:04:51
445	1	77	1	1.000	0.000	1.000	\N	\N	purchase_order	51	\N	\N	12	榴莲番薯 1件 AI录入	2026-05-11 21:04:51
446	1	37	1	1.000	0.000	1.000	\N	\N	purchase_order	51	\N	\N	12	枇杷 1件 AI录入	2026-05-11 21:04:51
447	1	78	1	3.000	0.000	3.000	\N	\N	purchase_order	51	\N	\N	12	奇异果 3件 AI录入	2026-05-11 21:04:51
448	1	79	1	2.000	0.000	2.000	\N	\N	purchase_order	51	\N	\N	12	番石榴 2件 AI录入	2026-05-11 21:04:51
449	2	80	1	6.000	0.000	6.000	\N	\N	purchase_order	52	\N	\N	1	冰鲜清远鸡 6只 AI录入	2026-05-11 21:35:31
450	2	81	1	5.000	0.000	5.000	\N	\N	purchase_order	52	\N	\N	1	冰鲜竹丝鸡 5只 AI录入	2026-05-11 21:35:31
451	2	82	1	8.000	0.000	8.000	\N	\N	purchase_order	53	\N	\N	1	娃娃菜 8包 AI录入	2026-05-11 21:38:53
452	2	83	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	大白菜 5斤 AI录入	2026-05-11 21:38:53
453	2	84	1	8.000	0.000	8.000	\N	\N	purchase_order	53	\N	\N	1	小旺菜 8斤 AI录入	2026-05-11 21:38:53
454	2	85	1	12.000	0.000	12.000	\N	\N	purchase_order	53	\N	\N	1	京包 12斤 AI录入	2026-05-11 21:38:53
455	2	86	1	6.000	0.000	6.000	\N	\N	purchase_order	53	\N	\N	1	椰菜花 6斤 AI录入	2026-05-11 21:38:53
456	2	87	1	15.000	0.000	15.000	\N	\N	purchase_order	53	\N	\N	1	西蘭花 15斤 AI录入	2026-05-11 21:38:53
457	2	88	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	水東芥菜 2包 AI录入	2026-05-11 21:38:53
458	2	89	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	青通 5包 AI录入	2026-05-11 21:38:53
459	2	90	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	上海青苗 3包 AI录入	2026-05-11 21:38:53
460	2	91	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	菜心 3包 AI录入	2026-05-11 21:38:53
461	2	92	1	20.000	0.000	20.000	\N	\N	purchase_order	53	\N	\N	1	冬瓜 20斤 AI录入	2026-05-11 21:38:53
462	2	93	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	苦瓜 5斤 AI录入	2026-05-11 21:38:53
463	2	94	1	6.000	0.000	6.000	\N	\N	purchase_order	53	\N	\N	1	南瓜 6斤 AI录入	2026-05-11 21:38:53
464	2	95	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	西葫蘆瓜 3斤 AI录入	2026-05-11 21:38:53
465	2	96	1	6.000	0.000	6.000	\N	\N	purchase_order	53	\N	\N	1	茄子 6斤 AI录入	2026-05-11 21:38:53
466	2	97	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	長水瓜 2斤 AI录入	2026-05-11 21:38:53
467	2	98	1	8.000	0.000	8.000	\N	\N	purchase_order	53	\N	\N	1	甜玉米 8包 AI录入	2026-05-11 21:38:53
468	2	99	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	白白菜 3包 AI录入	2026-05-11 21:38:53
469	2	100	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	荷蘭豆 2碟 AI录入	2026-05-11 21:38:53
470	2	101	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	板栗肉 2碟 AI录入	2026-05-11 21:38:53
471	2	102	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	甜豆(盒) 2盒 AI录入	2026-05-11 21:38:53
472	2	102	1	4.000	2.000	6.000	\N	\N	purchase_order	53	\N	\N	1	甜豆 4斤 AI录入	2026-05-11 21:38:53
473	2	103	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	青蘿蔔 2斤 AI录入	2026-05-11 21:38:53
474	2	104	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	白蘿蔔 5斤 AI录入	2026-05-11 21:38:53
475	2	105	1	10.000	0.000	10.000	\N	\N	purchase_order	53	\N	\N	1	泥紅蘿蔔 10斤 AI录入	2026-05-11 21:38:53
476	2	105	1	12.000	10.000	22.000	\N	\N	purchase_order	53	\N	\N	1	紅蘿蔔 12斤 AI录入	2026-05-11 21:38:53
477	2	106	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	紅菜頭 2斤 AI录入	2026-05-11 21:38:53
478	2	107	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	鮮鐵棍淮山 3包 AI录入	2026-05-11 21:38:53
479	2	108	1	7.000	0.000	7.000	\N	\N	purchase_order	53	\N	\N	1	馬鈴薯 7斤 AI录入	2026-05-11 21:38:53
480	2	109	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	芋頭 3斤 AI录入	2026-05-11 21:38:53
481	2	110	1	8.000	0.000	8.000	\N	\N	purchase_order	53	\N	\N	1	綠豆芽 8盒 AI录入	2026-05-11 21:38:53
482	2	111	1	6.000	0.000	6.000	\N	\N	purchase_order	53	\N	\N	1	黃豆芽 6盒 AI录入	2026-05-11 21:38:53
483	2	112	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	鮮黑木耳 2斤 AI录入	2026-05-11 21:38:53
484	2	113	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	白蘑菇 5碟 AI录入	2026-05-11 21:38:53
485	2	112	1	5.000	2.000	7.000	\N	\N	purchase_order	53	\N	\N	1	木耳 5碟 AI录入	2026-05-11 21:38:53
486	2	114	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	螺絲椒 2包 AI录入	2026-05-11 21:38:54
487	2	115	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	湖南椒 2包 AI录入	2026-05-11 21:38:54
488	2	116	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	大蔥 2斤 AI录入	2026-05-11 21:38:54
489	2	117	1	7.000	0.000	7.000	\N	\N	purchase_order	53	\N	\N	1	西芹 7斤 AI录入	2026-05-11 21:38:54
490	2	118	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	韭王 5包 AI录入	2026-05-11 21:38:54
491	2	119	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	韭菜 5包 AI录入	2026-05-11 21:38:54
492	2	120	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	白洋蔥 5斤 AI录入	2026-05-11 21:38:54
493	2	121	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	紅洋蔥 2斤 AI录入	2026-05-11 21:38:54
494	2	122	1	4.000	0.000	4.000	\N	\N	purchase_order	53	\N	\N	1	沙律菜 4盒 AI录入	2026-05-11 21:38:54
495	2	123	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	杭白菜 2包 AI录入	2026-05-11 21:38:54
496	2	124	1	10.000	0.000	10.000	\N	\N	purchase_order	53	\N	\N	1	菠菜 10包 AI录入	2026-05-11 21:38:54
497	2	125	1	4.000	0.000	4.000	\N	\N	purchase_order	53	\N	\N	1	枸杞葉 4包 AI录入	2026-05-11 21:38:54
498	2	126	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	毛瓜 3斤 AI录入	2026-05-11 21:38:54
499	2	127	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	青瓜 5斤 AI录入	2026-05-11 21:38:54
500	2	128	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	黃秋葵 3包 AI录入	2026-05-11 21:38:54
501	2	129	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	蓮藕 3斤 AI录入	2026-05-11 21:38:54
502	2	130	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	小土豆 5袋 AI录入	2026-05-11 21:38:54
503	2	131	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	芋仔 2袋 AI录入	2026-05-11 21:38:54
504	2	132	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	金針菇 3包 AI录入	2026-05-11 21:38:54
505	2	133	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	冬菇 5碟 AI录入	2026-05-11 21:38:54
506	2	134	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	杏鮑菇 3盒 AI录入	2026-05-11 21:38:54
507	2	135	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	蟹味菇 2盒 AI录入	2026-05-11 21:38:54
508	2	136	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	白玉菇 3盒 AI录入	2026-05-11 21:38:54
509	2	137	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	水果椒 2盒 AI录入	2026-05-11 21:38:54
510	2	138	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	指天椒 2盒 AI录入	2026-05-11 21:38:54
511	2	139	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	三色彩椒 2包 AI录入	2026-05-11 21:38:54
512	2	140	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	生薑 2袋 AI录入	2026-05-11 21:38:54
513	2	141	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	蒜頭 3袋 AI录入	2026-05-11 21:38:54
514	2	142	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	芹菜 5包 AI录入	2026-05-11 21:38:54
515	2	143	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	紅蔥 5包 AI录入	2026-05-11 21:38:54
516	2	144	1	5.000	0.000	5.000	\N	\N	purchase_order	53	\N	\N	1	芫茜 5包 AI录入	2026-05-11 21:38:54
517	2	145	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	真空淮山肉 2包 AI录入	2026-05-11 21:38:54
518	2	146	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	秀珍菇 2碟 AI录入	2026-05-11 21:38:54
519	2	147	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	萵筍 2斤 AI录入	2026-05-11 21:38:54
520	2	148	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	雞毛菜 2包 AI录入	2026-05-11 21:38:54
521	2	149	1	4.000	0.000	4.000	\N	\N	purchase_order	53	\N	\N	1	百合四頭 4包 AI录入	2026-05-11 21:38:54
522	2	150	1	3.000	0.000	3.000	\N	\N	purchase_order	53	\N	\N	1	毛豆仁 3碟 AI录入	2026-05-11 21:38:54
523	2	151	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	豌豆仁 2碟 AI录入	2026-05-11 21:38:54
524	2	152	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	青木瓜 2个 AI录入	2026-05-11 21:38:54
525	2	153	1	2.000	0.000	2.000	\N	\N	purchase_order	53	\N	\N	1	人參白薯 2包 AI录入	2026-05-11 21:38:54
526	1	78	2	-1.000	3.000	2.000	\N	\N	ai_message	159	\N	\N	12	奇异果 1件 AI录入	2026-05-30 08:10:59
527	1	8	1	2.000	0.000	2.000	\N	\N	purchase_order	54	\N	\N	12	苹果 2斤 AI录入	2026-05-30 16:06:30
528	1	38	3	-2.000	0.000	0.000	\N	\N	ai_message	389	\N	\N	12	草莓 2斤 AI录入	2026-05-30 21:55:05
529	1	8	3	-2.000	2.000	0.000	\N	\N	\N	\N	\N	\N	12	变质	2026-05-31 04:51:49
530	1	154	3	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	变质	2026-05-31 05:05:02
531	1	124	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
532	1	1	2	-32.000	120.000	88.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
533	1	8	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
534	1	155	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
535	1	156	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
536	1	57	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33
537	1	124	1	24.000	0.000	24.000	3.5000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
538	1	1	1	32.000	88.000	120.000	2.0000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
539	1	8	1	18.000	0.000	18.000	1.5000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
540	1	155	1	12.000	0.000	12.000	6.0000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
541	1	156	1	8.000	0.000	8.000	2.5000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
542	1	57	1	24.000	0.000	24.000	4.0000	\N	purchase_order	55	\N	\N	12	进货单 PO-20260531-00001	2026-05-31 07:32:04
543	1	38	3	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	12	运输损坏	2026-06-02 15:30:34
544	1	4	3	-1.000	150.000	149.000	\N	\N	\N	\N	\N	\N	12	变质	2026-06-03 20:12:56
545	1	76	2	-1.000	1.000	0.000	\N	\N	ai_message	463	\N	\N	12	牛油果 1箱 AI录入	2026-06-03 20:30:47
546	1	157	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
547	1	34	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
548	1	158	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
549	1	159	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
550	1	160	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
551	1	161	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
552	1	87	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
553	1	162	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
554	1	163	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
555	1	164	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
556	1	165	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
557	1	166	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
558	1	167	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
559	1	168	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
560	1	169	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
561	1	170	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
562	1	171	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
563	1	172	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
564	1	173	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
565	1	174	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
566	1	93	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
567	1	175	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
568	1	176	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
569	1	177	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
570	1	178	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
571	1	179	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
572	1	127	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
573	1	180	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
574	1	181	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
575	1	182	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
576	1	183	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
577	1	184	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
578	1	185	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
579	1	186	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
580	1	108	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
581	1	109	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
582	1	120	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
583	1	187	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
584	1	68	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
585	1	188	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
586	1	189	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
587	1	190	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
588	1	191	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
589	1	192	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
590	1	193	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
591	1	194	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
592	1	44	2	-1.000	1.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
593	1	85	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
594	1	195	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
595	1	196	2	0.000	0.000	0.000	\N	\N	\N	\N	\N	\N	8	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49
596	1	8	1	100.000	18.000	118.000	\N	\N	purchase_order	56	\N	\N	12	苹果 100斤 AI录入	2026-06-12 11:46:29
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leave_requests (id, employee_id, store_id, leave_type, start_date, end_date, total_days, reason, status, approved_by, approved_at, reject_reason, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: menu_templates; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.menu_templates (id, industry, name, is_active, sort_order, created_at, updated_at) FROM stdin;
1	apparel	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
2	finance	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
3	manufacturing	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
4	beauty	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
5	ecommerce	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
7	fresh	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
8	insurance	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
9	convenience	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:05:50
6	restaurant	默认模版	t	0	2026-06-12 05:05:50	2026-06-12 05:07:40
11	cross_border	默认模版	t	0	2026-06-12 12:16:49	2026-06-12 12:16:49
12	auto_repair	默认模版	t	0	2026-06-14 15:57:36	2026-06-14 15:57:36
\.


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
52	2026_06_11_120000_create_industries_table	4
53	2026_06_11_120100_add_industry_to_quick_actions	4
54	2026_06_12_120000_create_menu_templates_table	5
55	2026_06_12_120100_add_menu_template_to_quick_actions	5
56	2026_06_12_130000_add_api_base_to_industries	6
57	2026_06_13_100000_add_api_token_to_industries	7
58	2026_06_13_110000_add_ai_path_to_industries	8
59	2026_06_13_120000_add_ai_media_to_industries	9
60	2026_06_14_130000_add_greeting_to_industries	10
\.


--
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organizations (id, name, code, logo_url, contact_phone, settings, created_at, updated_at, deleted_at) FROM stdin;
1	舌尖香港	STJXG	\N	\N	\N	2026-03-22 14:54:14	2026-03-22 14:54:14	\N
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permissions (id, module, code, name, type, created_at, updated_at) FROM stdin;
1	dashboard	dashboard.view	查看工作台	1	2026-03-22 11:50:15	2026-03-22 11:50:15
2	inventory	inventory.view	查看库存	2	2026-03-22 11:50:15	2026-03-22 11:50:15
3	inventory	inventory.edit	手动修改库存	2	2026-03-22 11:50:15	2026-03-22 11:50:15
4	inventory	inventory.adjust	盘点调整	2	2026-03-22 11:50:15	2026-03-22 11:50:15
5	purchase	purchase.view	查看进货单	2	2026-03-22 11:50:15	2026-03-22 11:50:15
6	purchase	purchase.create	新建进货单	2	2026-03-22 11:50:15	2026-03-22 11:50:15
7	purchase	purchase.edit	编辑进货单	2	2026-03-22 11:50:15	2026-03-22 11:50:15
8	purchase	purchase.receive	确认收货	2	2026-03-22 11:50:15	2026-03-22 11:50:15
9	purchase	purchase.delete	删除进货单	2	2026-03-22 11:50:15	2026-03-22 11:50:15
10	products	products.view	查看商品	2	2026-03-22 11:50:15	2026-03-22 11:50:15
11	products	products.create	新增商品	2	2026-03-22 11:50:15	2026-03-22 11:50:15
12	products	products.edit	编辑商品	2	2026-03-22 11:50:15	2026-03-22 11:50:15
13	products	products.delete	删除商品	2	2026-03-22 11:50:15	2026-03-22 11:50:15
14	suppliers	suppliers.view	查看供应商	2	2026-03-22 11:50:15	2026-03-22 11:50:15
15	suppliers	suppliers.create	新增供应商	2	2026-03-22 11:50:15	2026-03-22 11:50:15
16	suppliers	suppliers.edit	编辑供应商	2	2026-03-22 11:50:15	2026-03-22 11:50:15
17	suppliers	suppliers.delete	删除供应商	2	2026-03-22 11:50:15	2026-03-22 11:50:15
18	expenses	expenses.view	查看支出记录	2	2026-03-22 11:50:15	2026-03-22 11:50:15
19	expenses	expenses.create	新建支出记录	2	2026-03-22 11:50:15	2026-03-22 11:50:15
20	expenses	expenses.edit	编辑支出记录	2	2026-03-22 11:50:15	2026-03-22 11:50:15
21	expenses	expenses.delete	删除支出记录	2	2026-03-22 11:50:15	2026-03-22 11:50:15
22	expenses	expenses.upload_receipt	上传支付凭证	2	2026-03-22 11:50:15	2026-03-22 11:50:15
23	expenses	expenses.export	导出财务数据	2	2026-03-22 11:50:15	2026-03-22 11:50:15
24	resumes	resumes.view	查看简历库	2	2026-03-22 11:50:15	2026-03-22 11:50:15
25	resumes	resumes.create	新增简历	2	2026-03-22 11:50:15	2026-03-22 11:50:15
26	resumes	resumes.edit	编辑简历	2	2026-03-22 11:50:15	2026-03-22 11:50:15
27	resumes	resumes.delete	删除简历	2	2026-03-22 11:50:15	2026-03-22 11:50:15
28	resumes	resumes.upload	批量上传简历	2	2026-03-22 11:50:15	2026-03-22 11:50:15
29	ai_assistant	ai_assistant.use	使用 AI 助手	2	2026-03-22 11:50:15	2026-03-22 11:50:15
30	ai_assistant	ai_assistant.report	实况上报	2	2026-03-22 11:50:15	2026-03-22 11:50:15
31	reports	reports.view	查看报表	1	2026-03-22 11:50:15	2026-03-22 11:50:15
32	reports	reports.export	导出报表	2	2026-03-22 11:50:15	2026-03-22 11:50:15
33	competitor	competitor.view	查看竞品数据	2	2026-03-22 11:50:15	2026-03-22 11:50:15
34	competitor	competitor.upload	上传竞品情报	2	2026-03-22 11:50:15	2026-03-22 11:50:15
35	competitor	competitor.edit	维护竞品数据	2	2026-03-22 11:50:15	2026-03-22 11:50:15
36	users	users.view	查看用户	2	2026-03-22 11:50:15	2026-03-22 11:50:15
37	users	users.create	新增用户	2	2026-03-22 11:50:15	2026-03-22 11:50:15
38	users	users.edit	编辑用户	2	2026-03-22 11:50:15	2026-03-22 11:50:15
39	users	users.delete	删除用户	2	2026-03-22 11:50:15	2026-03-22 11:50:15
40	roles	roles.view	查看角色	2	2026-03-22 11:50:15	2026-03-22 11:50:15
41	roles	roles.create	新建角色	2	2026-03-22 11:50:15	2026-03-22 11:50:15
42	roles	roles.edit	编辑角色	2	2026-03-22 11:50:15	2026-03-22 11:50:15
43	roles	roles.delete	删除角色	2	2026-03-22 11:50:15	2026-03-22 11:50:15
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
1	App\\Models\\User	1	auth_token	7ccc1389d66d4a7d19ee1c1caf974060542d7809a3e68e3a222bb76f44653445	["*"]	2026-03-22 06:59:53	\N	2026-03-22 06:59:53	2026-03-22 06:59:53
2	App\\Models\\User	1	auth_token	a644b61170ca3ba215bbc804dc4ff27859aa781b24f9e63bfa14f0c74e90e8c9	["*"]	2026-03-22 07:00:01	\N	2026-03-22 07:00:01	2026-03-22 07:00:01
3	App\\Models\\User	1	auth_token	edebd19e13681dad4e64c468b7bf89a4ce853cbc0c12ae2d9c1e4d829395dab0	["*"]	2026-03-31 04:22:35	\N	2026-03-31 04:22:08	2026-03-31 04:22:35
4	App\\Models\\User	8	auth_token	399e32286dd14371799c470fc314a054fc04b0168d5885bbe33a9b6713839a5d	["*"]	2026-03-31 04:22:14	\N	2026-03-31 04:22:10	2026-03-31 04:22:14
5	App\\Models\\User	8	auth_token	57a8ecbb6ac862c8c24367b3d521de65ba88fc9e27a41f5b3cec18327c1e0541	["*"]	2026-03-31 04:23:07	\N	2026-03-31 04:22:12	2026-03-31 04:23:07
6	App\\Models\\User	8	auth_token	351a03336de9f3b40789733bfcdfb4935b208036e0d74868b4cd11787b957441	["*"]	2026-03-31 04:22:20	\N	2026-03-31 04:22:13	2026-03-31 04:22:20
7	App\\Models\\User	8	auth_token	45b3ff2439e32155ec4957bcfcaaa776b1c46423928456ffe54dc6fd023c7ae0	["*"]	2026-03-31 04:22:48	\N	2026-03-31 04:22:13	2026-03-31 04:22:48
8	App\\Models\\User	8	auth_token	9d1c8c081b06c2119ac577152a94996c73934e89d427a53cd31065c29ca576e6	["*"]	2026-03-31 04:22:37	\N	2026-03-31 04:22:26	2026-03-31 04:22:37
9	App\\Models\\User	8	auth_token	6dfac3cf31759b1387101c998a10c27bf341422feacc4571d978b36e956ba7a0	["*"]	2026-03-31 04:34:27	\N	2026-03-31 04:34:27	2026-03-31 04:34:27
10	App\\Models\\User	8	auth_token	f252079aefa1eff21fb9cf64da16d79e34b36aea721908714c7087625f60f80a	["*"]	2026-03-31 04:43:14	\N	2026-03-31 04:43:14	2026-03-31 04:43:14
11	App\\Models\\User	8	auth_token	66c346a2752d3ba00c46e4aa8ec898bd62f04bcce6a587e2743f9ae48ad56c1d	["*"]	2026-03-31 05:22:10	\N	2026-03-31 05:20:41	2026-03-31 05:22:10
12	App\\Models\\User	8	auth_token	cb70b36c6686e9513c2e4eaf76cebbe304064c544de5ea6c14e61bb661e479c1	["*"]	2026-03-31 05:27:01	\N	2026-03-31 05:27:01	2026-03-31 05:27:01
13	App\\Models\\User	8	auth_token	a54344d8953b5775aa6751cdc602feb19f9c93cebcb86ad9d9a684f0281a2092	["*"]	2026-03-31 05:27:34	\N	2026-03-31 05:27:34	2026-03-31 05:27:34
14	App\\Models\\User	8	auth_token	be90e08b3c67c72aa7b17e842656f9cbb1f646b22f193ee69000acc68aa3ab3f	["*"]	2026-03-31 05:43:45	\N	2026-03-31 05:43:45	2026-03-31 05:43:45
15	App\\Models\\User	9	skill-token	dc47e2339c73300bf03d2ad33ae54f5836789d94377175c2588c55c142925873	["*"]	2026-04-01 09:27:04	\N	2026-03-31 06:25:46	2026-04-01 09:27:04
16	App\\Models\\User	8	auth_token	8e021ce3d1ee562284305cbc8de2164c2899dfbb8a16bdcded52dc61901bbe23	["*"]	2026-03-31 06:26:05	\N	2026-03-31 06:26:05	2026-03-31 06:26:05
17	App\\Models\\User	8	auth_token	de198f7c3a34fb6ed4838a8364c74f1e0271d7a142bc75ea3b3ce1e3fe7400ef	["*"]	2026-04-01 06:00:55	\N	2026-04-01 05:59:50	2026-04-01 06:00:55
18	App\\Models\\User	1	debug	c310ac2399e61ba3e64780c301ef6ae2ad488baa54ef95069c102ea5fc01467d	["*"]	2026-04-03 21:48:34	\N	2026-04-03 21:48:10	2026-04-03 21:48:34
19	App\\Models\\User	8	debug	6fc2aaa582ecbf5e653e613c6dd65c65bfdddc36d48862f42558194d0f0cef77	["*"]	2026-04-03 21:48:43	\N	2026-04-03 21:48:40	2026-04-03 21:48:43
20	App\\Models\\User	9	debug	f1246d668d9ecacbc16b9433ecf70eb88390b34c28354ad9b8346debdebbfdf3	["store:2"]	2026-04-03 21:49:30	\N	2026-04-03 21:49:27	2026-04-03 21:49:30
21	App\\Models\\User	10	auth_token	e7bc10d766b0422b5aa35aad337f1a69ccf875eb3e3b9e2c7d6b80502577ea26	["store:1"]	2026-04-03 21:58:58	\N	2026-04-03 21:54:08	2026-04-03 21:58:58
22	App\\Models\\User	1	auth_token	a730987954c054821b492c19d2cdf708470427ced9ff32318fafa8c6e5a39377	["store:2"]	\N	\N	2026-04-04 02:19:47	2026-04-04 02:19:47
23	App\\Models\\User	1	auth_token	de38735ee503e46018978a43f3d63edb152ffc3a46c26158a9d8176a1aaa5417	["store:2"]	\N	\N	2026-04-04 02:22:10	2026-04-04 02:22:10
24	App\\Models\\User	1	auth_token	4cb740e1221b7db932eddcb35c757aeda9f265ca8d97368afb2095069182bd69	["store:2"]	\N	\N	2026-04-04 02:22:13	2026-04-04 02:22:13
25	App\\Models\\User	1	auth_token	e5eb3ea2bdfcf9b593f37783ad1851270709dd79656df380a224c34bb36ea430	["store:2"]	\N	\N	2026-04-04 02:40:27	2026-04-04 02:40:27
26	App\\Models\\User	1	auth_token	1702f632aa07147551290c464490db7822e3c536a3786a1495dfbfaa045bb4f5	["store:2"]	\N	\N	2026-04-04 02:44:34	2026-04-04 02:44:34
27	App\\Models\\User	1	auth_token	b78ea413c2721eef45564c8169975e11361a7d2a06faca69a7e0a026800698dd	["store:2"]	\N	\N	2026-04-04 02:44:59	2026-04-04 02:44:59
28	App\\Models\\User	1	auth_token	8b7cac307e03cfc5fa2b2f3ba8f5ecdf98a55e55c1441b0b8d2d4dfe466a7c72	["store:2"]	\N	\N	2026-04-04 02:45:06	2026-04-04 02:45:06
29	App\\Models\\User	1	auth_token	1c745d59953062b00534f8100e1451928e15fd0e2b25a7f660bf504cefbf70cb	["store:2"]	\N	\N	2026-04-04 02:45:37	2026-04-04 02:45:37
30	App\\Models\\User	1	auth_token	cdd1b6bb55677696cf5ee5cb780c2d40cd18ce0dd3d8eef53930370e98f04fcd	["store:2"]	\N	\N	2026-04-04 02:47:00	2026-04-04 02:47:00
31	App\\Models\\User	1	auth_token	dd9a2e29abc2c3a14a6d5de569b4ea7cfb965c55e1831e1a9676c0852fac3100	["store:2"]	\N	\N	2026-04-04 02:47:14	2026-04-04 02:47:14
32	App\\Models\\User	1	auth_token	fd6d090a7b93c1e8c8ef87ea353a06c2d4172b6de31727896eddf39bc535048e	["store:2"]	\N	\N	2026-04-04 03:35:21	2026-04-04 03:35:21
33	App\\Models\\User	1	auth_token	aa45ed24cfacec23ca76b14611febc174f509d6d982ceeccbe4bf091ec35ef7b	["store:2"]	\N	\N	2026-04-04 03:58:41	2026-04-04 03:58:41
34	App\\Models\\User	11	auth_token	5bf5f8575dd87d8d88cf54340b7457d00a57033fe189abce35347f18fb79148c	["store:3"]	\N	\N	2026-04-04 06:20:56	2026-04-04 06:20:56
35	App\\Models\\User	11	auth_token	fd1d25c7e8541a699e5c5cc8d24d7eba8200fcc1a351fb24333f389ba80b642b	["store:3"]	\N	\N	2026-04-04 06:25:36	2026-04-04 06:25:36
36	App\\Models\\User	11	auth_token	b371e885fa2016321e6fe0daf51139e4145ace19dc6ff9d1a039163f5113195c	["store:3"]	\N	\N	2026-04-04 17:32:28	2026-04-04 17:32:28
37	App\\Models\\User	11	auth_token	3e797489f56441315e08d741344b205246256afde3d8a82715ff141187cacef9	["store:3"]	\N	\N	2026-04-07 01:06:04	2026-04-07 01:06:04
38	App\\Models\\User	1	openclaw	4c276ea6f36714a385fc6b45abbdecf2cdff192d58458b1c54d5ce747e0384da	["*"]	\N	\N	2026-04-07 07:45:53	2026-04-07 07:45:53
39	App\\Models\\User	1	auth_token	f158a61f216c9ccc30db7adb371501d77084ff328c75b584983a38025c4e8aa1	["store:2"]	\N	\N	2026-04-07 07:47:25	2026-04-07 07:47:25
40	App\\Models\\User	1	api:Demo User	f431bec6ee1887999063ea6e8bf533e67718a28e9ea809aa0486536be662988f	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
41	App\\Models\\User	2	api:Mr. Erick Stracke DDS	2c04679ab4358ded95a553d8e115f98db323cd170241f4d60f1e3f83175fc440	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
42	App\\Models\\User	3	api:郑志远	94f605169af394ca62ea3dcf3565add3e56bca0e29f4d7173afb734555ce1ee5	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
43	App\\Models\\User	4	api:Isidro Kuhic	6e69a2ca8a14a1bda5f50f2d92034b8f09eba7b767af1356f7e653fc95879f96	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
44	App\\Models\\User	5	api:Ernest Ryan	d5b2b1b533ad9d0ec4308a5dcb3a5863309d8c8e39c45e6a027db3fa3d83bc2e	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
45	App\\Models\\User	6	api:Marina Mraz	76ea477111bfa9464da346a6e3a0b73fe19a3be46cba6eaa9a2533af823380df	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
46	App\\Models\\User	8	api:超级管理员	b655a1486c40d0b0cf8113b967ce78cead06d4ba72ca4416a6d74f850cf12bc2	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
47	App\\Models\\User	9	api:西湾河店员	d9c16372d6f8ff85a0c84425005762e26709bb1ab928e8f3ed5a1a2593e78b67	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
48	App\\Models\\User	10	api:测试用户	6a71e4e4853de0a9d3233568a58dc6091481afeb077b5309c9e503c82184a166	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
49	App\\Models\\User	11	api:david	7721d5e94c1460b85e5b0d62e5298aa8167bc457fce4aa46d839818c18309303	["*"]	\N	\N	2026-04-11 13:06:50	2026-04-11 13:06:50
50	App\\Models\\User	1	api:new	d9a6d3576c353ad7f01fc2124f14dabcd0a853ef841192edabbee74bc1c160bc	["*"]	\N	\N	2026-04-11 20:57:50	2026-04-11 20:57:50
51	App\\Models\\User	1	api:1	a5886d734eee83b7e2abaa174b2a01aea42bed082523644fa2c67842dbc26485	["*"]	\N	\N	2026-04-11 20:58:16	2026-04-11 20:58:16
52	App\\Models\\User	1	api:2	e09562289d17c94b7ac1c13207e46338df4b3f63afd8989d1db724519680c348	["*"]	2026-04-11 22:02:44	\N	2026-04-11 20:58:28	2026-04-11 22:02:44
53	App\\Models\\User	1	api:1	4ec7962e39f5171f5b7e48356aa6654df24904ad8509293d43524fdbcef3ecda	["*"]	2026-04-15 23:48:14	\N	2026-04-15 21:34:32	2026-04-15 23:48:14
54	App\\Models\\User	11	api:2	0564953d9b33e94973e0807f3c17f64793ee2fc227cbeb8a23abe73313ac4b89	["*"]	2026-04-15 23:11:18	\N	2026-04-15 22:48:48	2026-04-15 23:11:18
55	App\\Models\\User	10	api:3	d1e72cc9cb3e673b8eb154b6c3a5ce0415256270c56039b25ab633c270f05111	["*"]	2026-04-16 12:37:18	\N	2026-04-15 23:52:29	2026-04-16 12:37:18
56	App\\Models\\User	11	api:333	7f16b43c2e0cd4e0b8e9ea0aa2136874618e02d75f238db2779a7597abd59e4d	["*"]	2026-04-16 10:11:15	\N	2026-04-16 01:00:22	2026-04-16 10:11:15
57	App\\Models\\User	11	api:david	208c094169cb25e8a24a55b43b708739a53453135da69c0db65ce3f265fda9a8	["*"]	2026-04-16 13:45:31	\N	2026-04-16 12:50:32	2026-04-16 13:45:31
58	App\\Models\\User	11	api:米	686ac67dc1113e13de49f396a3b8e2a2859174f1d7212f822b51a6175155e16e	["*"]	2026-04-17 07:04:08	\N	2026-04-16 14:16:42	2026-04-17 07:04:08
59	App\\Models\\User	5	api:12	8bb592b0370b1f8a2802ec200737ee8d0cca379fe5519ada003af03684fc7180	["*"]	\N	\N	2026-04-16 14:26:39	2026-04-16 14:26:39
60	App\\Models\\User	11	api:peter	320ea110a05c576c407e2efedaa07b2b7e0a88f93ac3bcb79115f9bed999aafe	["*"]	\N	\N	2026-04-16 22:33:35	2026-04-16 22:33:35
61	App\\Models\\User	5	api:KT	dfa7b448f02ccace38ac330e85917efec50e10305d5cb4b7e03e59745112ca64	["*"]	2026-04-16 22:45:32	\N	2026-04-16 22:34:04	2026-04-16 22:45:32
62	App\\Models\\User	8	auth_token	fb069541a7fe9d98329eb8af56209e7b961c343d564e9e14b4523728d50583d7	["store:3"]	2026-04-17 00:05:33	2026-05-16 23:57:03	2026-04-16 23:57:03	2026-04-17 00:05:33
63	App\\Models\\User	1	auth_token	5892f7a75f0716ac52a347612a59ea12818e14af772d586029829f373e3b985a	["store:2"]	\N	2026-05-26 18:13:38	2026-04-26 18:13:38	2026-04-26 18:13:38
66	App\\Models\\User	1	auth_token	f52311ced3498c8eaa69f0d1ffc20e68fbcb49d914dde527a1577f53c6767705	["store:2"]	\N	2026-05-26 18:21:23	2026-04-26 18:21:23	2026-04-26 18:21:23
67	App\\Models\\User	1	auth_token	6f3d8c761c730ae817d7a9643f31227a3956ac4f8d168fc877052d784a3f27e8	["store:2"]	\N	2026-05-26 18:25:25	2026-04-26 18:25:25	2026-04-26 18:25:25
68	App\\Models\\User	12	auth_token	1df0bdf92ced3499f22bdc08b20a759fc4e6392ea407e0b3f6058c379be44851	["store:1"]	2026-04-26 19:57:55	2026-05-26 19:25:27	2026-04-26 19:25:27	2026-04-26 19:57:55
69	App\\Models\\User	12	auth_token	4edf0197e0fc37f5c724fc602661ffc879952f4045765c4ae08eb02a4ad76385	["store:1"]	2026-04-27 22:42:13	2026-05-27 14:44:52	2026-04-27 14:44:52	2026-04-27 22:42:13
70	App\\Models\\User	12	auth_token	bd8adcc507299605435240b93aae10e630e411050da3f39800202f5ecc0bb596	["store:1"]	2026-05-11 20:29:00	2026-05-27 16:10:58	2026-04-27 16:10:58	2026-05-11 20:29:00
71	App\\Models\\User	12	auth_token	852647b6a71eaac8e6d04cca5f5cf289a5a728514c21d11e6105ac3759d1011b	["store:1"]	2026-04-27 21:33:04	2026-05-27 21:28:27	2026-04-27 21:28:27	2026-04-27 21:33:04
72	App\\Models\\User	1	test	3e7faa88d7240e58ddb2c3d54774575ecae839617733309573c84714a21ed633	["*"]	\N	\N	2026-04-27 21:29:57	2026-04-27 21:29:57
73	App\\Models\\User	1	test	996e1db327488cfcb4d2896cfd690b6d4f6f960208f82598a524b116109ee057	["*"]	2026-04-27 21:55:55	\N	2026-04-27 21:36:35	2026-04-27 21:55:55
74	App\\Models\\User	12	auth_token	eac63c6ac10e7b25bedc449eb343616607c7ae01a837e2770170efbae13807a9	["store:1"]	2026-04-27 21:53:50	2026-05-27 21:36:41	2026-04-27 21:36:41	2026-04-27 21:53:50
75	App\\Models\\User	1	test	5b52248145f0c9fb053f5ec4ca2abe979867e17f8775a64c9706103685bffdab	["*"]	2026-04-27 21:57:51	\N	2026-04-27 21:56:41	2026-04-27 21:57:51
76	App\\Models\\User	12	auth_token	15980e03d8f1de6ba1bf9cec83cafe5550e8e4f6d922a5cdb07f6c4a0256f06d	["store:1"]	2026-04-27 22:59:03	2026-05-27 22:58:40	2026-04-27 22:58:40	2026-04-27 22:59:03
77	App\\Models\\User	1	auth_token	a533ff6af8a683841106c546fc934cda77efc7e38362996b64c5dbea40913f37	["store:2"]	2026-05-11 21:48:37	2026-05-28 08:48:32	2026-04-28 08:48:32	2026-05-11 21:48:37
78	App\\Models\\User	13	auth_token	36bab91df317c46f6b0a9c37eead0175906ef16db4e924a5da0dc7786f72cc8f	["store:1"]	2026-05-11 20:17:09	2026-05-28 12:45:31	2026-04-28 12:45:31	2026-05-11 20:17:09
79	App\\Models\\User	12	auth_token	1cd729766e44240901ab9b62984707ccdd1fbf629a3bb5770b853a896cc8137d	["store:1"]	2026-04-29 07:52:39	2026-05-29 06:06:00	2026-04-29 06:06:00	2026-04-29 07:52:39
80	App\\Models\\User	14	api:tom	63aa5b6ca7028a74c6f55645c7be096b51b00912f0531fd61c932e8c35a36ca5	["*"]	\N	\N	2026-05-11 05:19:26	2026-05-11 05:19:26
82	App\\Models\\User	12	auth_token	44ea6fdb0208e66ce5c1d0be6acbb05edfa30a76e5891fd3417fd7ce9906b7f4	["store:1"]	2026-05-11 05:43:30	2026-06-10 05:43:30	2026-05-11 05:43:30	2026-05-11 05:43:30
84	App\\Models\\User	12	auth_token	3e71b5cb69b10f58f5423c650a3a436a098161671b65c5216e69fc85b9e81690	["store:1"]	2026-05-11 09:04:31	2026-06-10 07:52:21	2026-05-11 07:52:21	2026-05-11 09:04:31
85	App\\Models\\User	12	auth_token	70c93b75661591be2eafb5a7f2283907fb37d9929cd7846b9c2851fdde78480f	["store:1"]	2026-05-11 07:53:46	2026-06-10 07:53:41	2026-05-11 07:53:41	2026-05-11 07:53:46
86	App\\Models\\User	12	auth_token	07dea6da52423266f4a478a342da4681db7026d0c63c48eb63cde41d2b0ce0c1	["store:1"]	2026-05-11 19:55:27	2026-06-10 19:43:45	2026-05-11 19:43:45	2026-05-11 19:55:27
87	App\\Models\\User	12	auth_token	d7aadd57c20c3a5339ae18c04563a7792f0806b97c475d4ded4009921788a4fd	["store:1"]	2026-05-11 19:51:45	2026-06-10 19:49:55	2026-05-11 19:49:55	2026-05-11 19:51:45
88	App\\Models\\User	12	auth_token	e0ba2cdc263c8e3d6f9f46384db63f42afde8788475241aa685b80052fb945dd	["store:1"]	2026-05-11 20:17:36	2026-06-10 20:16:56	2026-05-11 20:16:56	2026-05-11 20:17:36
89	App\\Models\\User	12	auth_token	1c76a07d764ffdaa3e495c6c9e6b35911e3d703a0a3aa63e06b11b74cbb1828a	["store:1"]	2026-05-11 21:09:07	2026-06-10 20:58:31	2026-05-11 20:58:31	2026-05-11 21:09:07
90	App\\Models\\User	12	auth_token	d76c90e32c8f9a614d11449c755fae82729fcb2e3b47a3ff6ba4d0aa72348457	["store:1"]	2026-05-11 21:26:14	2026-06-10 21:22:45	2026-05-11 21:22:45	2026-05-11 21:26:14
91	App\\Models\\User	12	auth_token	43c578f804239cdae95788937126f04de6d1d5c911fb9b8bc3f7eddca95eb3df	["store:1"]	\N	2026-06-25 18:23:17	2026-05-26 18:23:17	2026-05-26 18:23:17
93	App\\Models\\User	12	auth_token	18ab418dc1920d2b35f12819a7d8cc02f0c21720bb98c10dcfc19089a5be5ff6	["store:1"]	\N	2026-06-27 16:51:57	2026-05-28 16:51:57	2026-05-28 16:51:57
94	App\\Models\\User	12	auth_token	d0bc3d89ad2c390ca27b0e1d423d2735523cf2f6277c47f24650db3663c69447	["store:1"]	2026-05-30 13:05:42	2026-06-29 06:56:36	2026-05-30 06:56:36	2026-05-30 13:05:42
95	App\\Models\\User	8	auth_token	1d06244765e50a1bf6132bd8347977454cd7365923e1d5ab81516993a6cf95ad	["store:3"]	2026-05-30 07:03:32	2026-06-29 07:03:28	2026-05-30 07:03:28	2026-05-30 07:03:32
96	App\\Models\\User	8	auth_token	0d138f1aa91c481ed81729927426bae11efe7b0c9769161b610ff5cf5bca9397	["store:3"]	2026-05-30 07:06:51	2026-06-29 07:06:39	2026-05-30 07:06:39	2026-05-30 07:06:51
98	App\\Models\\User	8	auth_token	cd42ad16b22c52b47ad9f2e652316a04acf9c196564f01a2fd4e74006191c879	["store:3"]	2026-05-30 07:23:28	2026-06-29 07:23:28	2026-05-30 07:23:28	2026-05-30 07:23:28
99	App\\Models\\User	12	auth_token	ca08fbc2ae1f7fed361378dd7855dc9cf67ded93bb1c4eaa2ce2da2c655cce01	["store:1"]	2026-05-30 07:29:38	2026-06-29 07:27:56	2026-05-30 07:27:56	2026-05-30 07:29:38
100	App\\Models\\User	8	auth_token	6dcf5f465b5388fcf93b28e939b094c5e98410e449afd03e85f549203653551c	["store:3"]	2026-05-30 07:51:50	2026-06-29 07:51:49	2026-05-30 07:51:49	2026-05-30 07:51:50
101	App\\Models\\User	12	auth_token	a350071f6c4727a6e6332bb22e062c29e0f657ae5814ed2232d7f8aa70ec45d4	["store:1"]	2026-05-30 10:56:45	2026-06-29 08:16:48	2026-05-30 08:16:48	2026-05-30 10:56:45
102	App\\Models\\User	8	auth_token	af4c26d4283837e9a777455ff1d3b62fedc0cc0d01459d721bdf4457c9c85f7c	["store:3"]	\N	2026-06-29 10:08:50	2026-05-30 10:08:50	2026-05-30 10:08:50
103	App\\Models\\User	8	auth_token	954a9efd52b3fe883b061afdd04f6c73293e2d02b7e8326d00dcba998de6802e	["store:3"]	2026-05-30 10:15:11	2026-06-29 10:15:11	2026-05-30 10:15:11	2026-05-30 10:15:11
105	App\\Models\\User	8	auth_token	2f07031cf44ec8b28e0b348c9a122c8bae8f81962dc07b1e7b4c3be62acbcad1	["store:3"]	\N	2026-06-29 10:29:47	2026-05-30 10:29:47	2026-05-30 10:29:47
106	App\\Models\\User	8	auth_token	06c536c5e975c580a188e0841419ccba904f090dc5fa78a6c308bda8b6be202b	["store:3"]	2026-05-30 10:39:22	2026-06-29 10:39:19	2026-05-30 10:39:19	2026-05-30 10:39:22
107	App\\Models\\User	8	auth_token	562ae896ab9c975c2d113bbaea4bc5e321678802333a04b2525a766196b2f577	["store:3"]	\N	2026-06-29 10:41:41	2026-05-30 10:41:41	2026-05-30 10:41:41
108	App\\Models\\User	12	auth_token	78da1b09b699d47915dec1efcad5c4f866d7769263e7ccc456fab3fe81e8a3e9	["store:1"]	2026-05-30 10:50:45	2026-06-29 10:50:33	2026-05-30 10:50:33	2026-05-30 10:50:45
109	App\\Models\\User	12	auth_token	924480034df2dc71152872ca8599d69214d3c825aeb842d33f9857ce297213be	["store:1"]	2026-05-30 11:30:09	2026-06-29 10:51:49	2026-05-30 10:51:49	2026-05-30 11:30:09
111	App\\Models\\User	12	auth_token	6e3f45e0b1a47e187860246a3e98f3f76e836136e5c3605e379205878f5bbd49	["store:1"]	2026-05-30 11:52:14	2026-06-29 11:34:21	2026-05-30 11:34:21	2026-05-30 11:52:14
112	App\\Models\\User	12	auth_token	152bbabde5b0a60a5e530c11ad8c0500662d03381e27d334fd473cba19bb4799	["store:1"]	2026-05-30 12:03:02	2026-06-29 11:53:44	2026-05-30 11:53:44	2026-05-30 12:03:02
113	App\\Models\\User	8	auth_token	7c52d0d67ed2b6f3d020741ad3b6e825a33098f7642b424b2ab7faedf7f6c508	["store:3"]	\N	2026-06-29 12:00:09	2026-05-30 12:00:09	2026-05-30 12:00:09
114	App\\Models\\User	8	auth_token	cada41f7ca114a02e929bf964dcab7c62bb3789e6dcd3ad36abcc3647815f169	["store:3"]	\N	2026-06-29 12:01:55	2026-05-30 12:01:55	2026-05-30 12:01:55
115	App\\Models\\User	12	auth_token	972de5d5ac9e648c577da25d1e64dafc76de880436419506d1e5565a1ffa564a	["store:1"]	\N	2026-06-29 12:03:29	2026-05-30 12:03:29	2026-05-30 12:03:29
116	App\\Models\\User	12	auth_token	f5c359c28b68a714691fd9ad97f440dee7aa3393d1d41597f3b2544d9bb1ed39	["store:1"]	\N	2026-06-29 12:06:43	2026-05-30 12:06:43	2026-05-30 12:06:43
117	App\\Models\\User	12	auth_token	9357484d2041a08fb7f559265fe0b4a276e5131d0bd379c9617f468b9d6b1450	["store:1"]	\N	2026-06-29 12:07:18	2026-05-30 12:07:18	2026-05-30 12:07:18
118	App\\Models\\User	8	auth_token	9747fae5fbedf2548e68fe01c7eefb4c8b003c6b7031e1cd8660cb6cfd5e8f5c	["store:3"]	\N	2026-06-29 13:36:00	2026-05-30 13:36:00	2026-05-30 13:36:00
119	App\\Models\\User	8	auth_token	bc672a309921c6c7a09544b3755040454d7b01af38094aba8c23db287698d409	["store:3"]	\N	2026-06-29 13:56:08	2026-05-30 13:56:08	2026-05-30 13:56:08
120	App\\Models\\User	8	auth_token	76c3c1326e320630f35989219dccd3493adda8715504ca11b5d18ffb5ee6d8ec	["store:3"]	\N	2026-06-29 14:21:04	2026-05-30 14:21:04	2026-05-30 14:21:04
121	App\\Models\\User	8	auth_token	0e3b5bb5444dbb35a4aa485c9b83b5ff504f94f8b9c478ad29685708d6f36c27	["store:3"]	\N	2026-06-29 14:22:33	2026-05-30 14:22:33	2026-05-30 14:22:33
122	App\\Models\\User	8	auth_token	4dc12257122f4fc9e98a756728ce102ed4ff8faa190b6226301dd7e932fe66b4	["store:3"]	\N	2026-06-29 15:01:31	2026-05-30 15:01:31	2026-05-30 15:01:31
123	App\\Models\\User	12	auth_token	056500fb717837b306d7116f592ba69f8068bb5a12a2767248b796782492b5a2	["store:1"]	\N	2026-06-29 15:29:13	2026-05-30 15:29:13	2026-05-30 15:29:13
124	App\\Models\\User	12	auth_token	3fd1ddde0507a5a1dce289bb3478dc0d4bb9a0e7b91a88972d7f5277e8a51703	["store:1"]	\N	2026-06-29 16:03:55	2026-05-30 16:03:55	2026-05-30 16:03:55
125	App\\Models\\User	12	auth_token	e9d9b3f67b6a8de9d2a0528270b1874e7923928a226a240c7488e1524cb0a0f7	["store:1"]	\N	2026-06-29 16:05:04	2026-05-30 16:05:04	2026-05-30 16:05:04
126	App\\Models\\User	12	auth_token	5d183656ad1904ab644f14d7698cdd0c9c1abf39fe6a251ad55687817ba9d2b3	["store:1"]	\N	2026-06-29 21:46:22	2026-05-30 21:46:22	2026-05-30 21:46:22
127	App\\Models\\User	12	auth_token	dfa91c9d2baca3f4bddbc7def091b304c4a09506e8734f9dacf192bf0247e66e	["store:1"]	\N	2026-06-29 21:49:55	2026-05-30 21:49:55	2026-05-30 21:49:55
128	App\\Models\\User	12	auth_token	ce4583cb06c1320b83a051dffb0cdc813d4dc86a4da79727c676d7e1c3209548	["store:1"]	\N	2026-06-30 08:00:19	2026-05-31 08:00:19	2026-05-31 08:00:19
129	App\\Models\\User	12	auth_token	a5f8fe00608b6ef3c7ca2b482ef4a8a8c05519fb9ec53e790a1d1b35d47119fd	["store:1"]	\N	2026-06-30 09:16:18	2026-05-31 09:16:18	2026-05-31 09:16:18
130	App\\Models\\User	12	auth_token	d87839c6fc61cfe8cec6f10b8c84979153879d6b20f95ebbe337c17e70d6bc71	["store:1"]	\N	2026-06-30 09:36:42	2026-05-31 09:36:42	2026-05-31 09:36:42
131	App\\Models\\User	12	auth_token	eac7a1263577ac703d88040c7e895bcb213b689de759786683919881535e9b61	["store:1"]	\N	2026-06-30 19:22:18	2026-05-31 19:22:18	2026-05-31 19:22:18
132	App\\Models\\User	12	auth_token	43e7022e629e180bb001c642e19d52f7d5b59536a39343958f2d9be09fb00048	["store:1"]	\N	2026-07-01 17:58:28	2026-06-01 17:58:28	2026-06-01 17:58:28
133	App\\Models\\User	12	auth_token	84559baf35b872570bf05eedeadf5ca30583f8d898320f25bf535fc1dd12c444	["store:1"]	\N	2026-07-02 08:23:35	2026-06-02 08:23:35	2026-06-02 08:23:35
134	App\\Models\\User	8	auth_token	22435418655fc792e135b20177b728991d3db5dea2cd4610d09ae5374d59fb9d	["store:3"]	\N	2026-07-02 16:17:21	2026-06-02 16:17:21	2026-06-02 16:17:21
135	App\\Models\\User	12	auth_token	9ea9ce7456d964e5d0ef95bd50d5c8f00e1f95580828335f4e171016ab6c7dd0	["store:1"]	\N	2026-07-02 16:21:21	2026-06-02 16:21:21	2026-06-02 16:21:21
136	App\\Models\\User	12	auth_token	0b4d152323c9c61844deb454b61a2ae251537c9336e857bbfddbd189d992c396	["store:1"]	\N	2026-07-02 16:21:55	2026-06-02 16:21:55	2026-06-02 16:21:55
137	App\\Models\\User	12	auth_token	b745dab0b44f45e4f3137afcc0074a2d1535dc7f7a497ba266562ad8f15fb89f	["store:1"]	\N	2026-07-02 16:24:08	2026-06-02 16:24:08	2026-06-02 16:24:08
138	App\\Models\\User	12	auth_token	821df8bf5c32071dcd44326898a50041152c0ec2cdb687094e06358ebfad014b	["store:1"]	\N	2026-07-03 00:25:59	2026-06-03 00:25:59	2026-06-03 00:25:59
139	App\\Models\\User	12	auth_token	5f67e99dae9857e1a516b1b652a3e5a58f4d2b4635114417d58314902d0bcb47	["store:1"]	\N	2026-07-03 00:43:54	2026-06-03 00:43:54	2026-06-03 00:43:54
140	App\\Models\\User	12	auth_token	e3eb9c9c41677a14e1c05d40252a5d79502ec6f7450a1e2fd82c3e219be2a0a3	["store:1"]	\N	2026-07-03 00:45:29	2026-06-03 00:45:29	2026-06-03 00:45:29
141	App\\Models\\User	12	auth_token	81bfbe1e5a2fcce439762d11d5ae6f28ec2b141e331436ebc2482c196bcad023	["store:1"]	\N	2026-07-03 00:45:49	2026-06-03 00:45:49	2026-06-03 00:45:49
142	App\\Models\\User	12	auth_token	0691f110975ef33d5e7eba0f735c06343015eb11ca2eea7dd0fb40c6c81932ee	["store:1"]	\N	2026-07-03 01:06:48	2026-06-03 01:06:48	2026-06-03 01:06:48
143	App\\Models\\User	12	auth_token	f37097ea837f64265e2e3e965d76aba18160ddac1ddf04a0e0a3c4e203a6eb84	["store:1"]	\N	2026-07-03 01:25:21	2026-06-03 01:25:21	2026-06-03 01:25:21
144	App\\Models\\User	12	auth_token	839d7193f98e43299736b2f0cb03a4c045c67f1fae059c8da935cf4dd142b638	["store:1"]	\N	2026-07-03 01:32:48	2026-06-03 01:32:48	2026-06-03 01:32:48
145	App\\Models\\User	12	auth_token	63f4aff20f2b0574f68cadff73c2034a3f701d0f99bac261af3457f4be017241	["store:1"]	\N	2026-07-03 01:33:14	2026-06-03 01:33:14	2026-06-03 01:33:14
146	App\\Models\\User	12	auth_token	d2eaaf06aaacfc9b01d2dbc113a27ca21d86a98815246273d19b4da4fb3de20b	["store:1"]	\N	2026-07-03 02:12:51	2026-06-03 02:12:51	2026-06-03 02:12:51
147	App\\Models\\User	12	auth_token	a879b4c942545cfde5576bc84ea15cc8adb2f93e1b72e198a5f1863b14552f01	["store:1"]	\N	2026-07-03 02:28:28	2026-06-03 02:28:28	2026-06-03 02:28:28
148	App\\Models\\User	12	auth_token	28ff4c122afa49591e088d945277a609b1ff62287821005e97e135de7b980052	["store:1"]	\N	2026-07-07 10:54:41	2026-06-07 10:54:41	2026-06-07 10:54:41
149	App\\Models\\User	12	auth_token	1986c71269213a07984fce2443ac306fd920414d1f9aced35b15347656e9d8ee	["store:1"]	\N	2026-07-10 10:30:06	2026-06-10 10:30:06	2026-06-10 10:30:06
150	App\\Models\\User	12	auth_token	08a10a7c7de433bc76446d23f0cd23977885bc919ccfb592551383ac25fe9b42	["store:1"]	\N	2026-07-10 10:37:15	2026-06-10 10:37:15	2026-06-10 10:37:15
151	App\\Models\\User	12	auth_token	be8fc0024f547ad869d5d31898b17e302634f2f34460c363914685c5ab2d0d14	["store:1"]	\N	2026-07-11 22:22:08	2026-06-11 22:22:08	2026-06-11 22:22:08
152	App\\Models\\User	8	auth_token	edc05e7c413114385b36f328091dc4d422d17b703d7fe24472ce0f1311b24e7d	["store:4"]	\N	2026-07-11 23:21:47	2026-06-11 23:21:47	2026-06-11 23:21:47
153	App\\Models\\User	8	auth_token	fe1d939ae57794df056e83f1631875f42747f73c049dfb16eb135fb234c07080	["store:4"]	\N	2026-07-11 23:24:01	2026-06-11 23:24:01	2026-06-11 23:24:01
154	App\\Models\\User	8	auth_token	2b569f09ce9c7cbf8cfc237a2c221a04e56476ad377bac3bc1022c14f5085d3a	["store:4"]	\N	2026-07-11 23:44:48	2026-06-11 23:44:48	2026-06-11 23:44:48
155	App\\Models\\User	8	auth_token	ac178d2b6f6e7dea0b2449019243f0614023347da3551d5d6a8d1100deb4dec2	["store:4"]	\N	2026-07-12 00:18:33	2026-06-12 00:18:33	2026-06-12 00:18:33
156	App\\Models\\User	8	auth_token	37770342ed9dd159b61c072a06a1ff3fd1c91b9bdb0fdc5dc50ea98153d9048d	["store:4"]	\N	2026-07-12 05:06:18	2026-06-12 05:06:18	2026-06-12 05:06:18
157	App\\Models\\User	8	auth_token	73b4abf83d8972fd9bfa8e5a58ec9a6e00e4accab069b8b1f98e81f329dcf252	["store:4"]	\N	2026-07-12 05:07:11	2026-06-12 05:07:11	2026-06-12 05:07:11
158	App\\Models\\User	8	auth_token	1520fcb7c16550e0a66b03429f51a082dc088d31588e1be4f83ba3e725cba14b	["store:4"]	\N	2026-07-12 05:07:40	2026-06-12 05:07:40	2026-06-12 05:07:40
159	App\\Models\\User	12	auth_token	0934cb503f1ae75cc4590d2a004385777c6309551edd4b21f7757f17e8e7e405	["store:1"]	\N	2026-07-12 05:23:39	2026-06-12 05:23:39	2026-06-12 05:23:39
160	App\\Models\\User	12	auth_token	2aadb3b88c669be245a11fe3786067502068b752bf4b4be197cb353b13330578	["store:1"]	\N	2026-07-12 11:05:28	2026-06-12 11:05:28	2026-06-12 11:05:28
161	App\\Models\\User	8	auth_token	6f6b2df2b9e3e799c01d989a7ada8439fd86addb604e33fbba9621e518fb5629	["store:4"]	\N	2026-07-12 12:17:23	2026-06-12 12:17:23	2026-06-12 12:17:23
162	App\\Models\\User	12	auth_token	dfc1988b5377b173e07a5eea87910f9857bf1257aedb3ad4e68245b99de4fe7d	["store:1"]	\N	2026-07-12 20:12:46	2026-06-12 20:12:46	2026-06-12 20:12:46
163	App\\Models\\User	12	auth_token	fddf4e4848566c9bc7f8f496bd35f26729dc246dfa4146f7eb69902af3e99189	["store:1"]	\N	2026-07-12 23:16:00	2026-06-12 23:16:00	2026-06-12 23:16:00
164	App\\Models\\User	12	auth_token	28b30ac026a1d3fa78c7244edeb1b00f65c983d1aa48a492a4cd058a6902b0da	["store:1"]	\N	2026-07-13 09:02:58	2026-06-13 09:02:58	2026-06-13 09:02:58
165	App\\Models\\User	12	auth_token	2f1b8d19357791453d60ac3ae4ad99637ae88beb7edfba63c156dad429e9510c	["store:1"]	\N	2026-07-14 01:16:19	2026-06-14 01:16:19	2026-06-14 01:16:19
166	App\\Models\\User	12	auth_token	36df1a25bbf8c284dba3fb404387a5b5bc334b2985079636a406b4166af203b9	["store:1"]	\N	2026-07-14 12:12:51	2026-06-14 12:12:51	2026-06-14 12:12:51
167	App\\Models\\User	12	auth_token	0af5046beaefa5e9713f9426893118dd771caea0b0caaf44202647ae8df882f4	["store:1"]	\N	2026-07-14 16:30:16	2026-06-14 16:30:16	2026-06-14 16:30:16
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.posts (id, user_id, title, content, published, created_at, updated_at) FROM stdin;
1	1	Eos et optio ea earum.	Dolor consequatur voluptatem deserunt reprehenderit et officiis. Eum dignissimos architecto sapiente saepe veniam rerum et.\n\nUt ducimus dolorem sed soluta veniam. Ullam sint asperiores qui ullam occaecati magni enim qui. Iure quos fuga et omnis exercitationem repellat maiores impedit.\n\nEt quis quo laboriosam magni et cumque et rerum. Magni ut excepturi minus aut non dicta. Distinctio aut et aut cum.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
2	1	Aut harum eum nisi voluptatibus explicabo.	Deserunt dolor nihil dolorum temporibus quas. Blanditiis amet suscipit cupiditate autem. Atque ut perferendis quasi sit ipsa ab in omnis. Vel incidunt eos et numquam fuga omnis accusamus.\n\nIn doloribus quaerat quia minima necessitatibus fugiat. Officiis occaecati deleniti qui incidunt. Quas veniam voluptas ex ut magnam. Iste illo rem officia porro eveniet aut.\n\nAdipisci blanditiis soluta eos quidem dolorem consequuntur. Deserunt molestiae voluptatibus aut nam eaque. Velit veritatis harum dolorum quaerat repudiandae.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
3	1	Est vitae placeat quia iusto magni facilis quia.	Tempora sint nam sunt id nostrum autem ducimus. Consectetur aperiam quam consequatur laborum aut asperiores qui. Laboriosam ipsa laboriosam rerum et et quia dignissimos error. Ullam eum distinctio ullam maiores sunt fuga quam ratione. Amet voluptatibus repellat tempora voluptatem explicabo iusto.\n\nCulpa autem a aperiam aspernatur dolorem eligendi. Veritatis ea non facilis.\n\nEsse repellat soluta autem a placeat rerum. Sed nemo nihil voluptates sunt natus consequatur enim. Rerum voluptas tempore in veritatis et.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
4	1	Nihil veniam repellat enim dicta rem.	Et fugit autem quasi vel aut asperiores. Omnis eum ut in sint. Beatae quidem et optio expedita assumenda id in. Tempora minus rem dolores eos.\n\nEt voluptas minima qui non vitae rem hic qui. Consequuntur laborum eligendi voluptatem qui. Quia quisquam qui facilis saepe nam. Laboriosam sit quia quis nostrum est sequi.\n\nEt sed voluptatem quis impedit non dolorem eos. Aut deserunt ipsa quia necessitatibus. Voluptate sit repellat aut perspiciatis ut voluptatem laboriosam. Itaque sunt qui eos amet.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
5	1	Laborum optio quia cupiditate aut magni quasi aliquam.	Distinctio hic accusantium consequatur soluta illo libero. Voluptatum pariatur nisi qui quo sed aperiam quia. Quisquam sit occaecati perspiciatis non temporibus ea.\n\nDoloremque consequatur omnis soluta voluptas. Atque cupiditate et quis enim optio et autem. Quam esse perspiciatis consectetur possimus facilis est asperiores ea. Voluptatum natus quis velit cupiditate.\n\nItaque culpa necessitatibus doloribus architecto. Ab sunt libero numquam assumenda. Voluptas fuga omnis ea itaque.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
6	2	Porro impedit magnam placeat molestiae rerum molestiae omnis.	Voluptatibus non possimus quasi sunt maxime aut reiciendis. Dolor est placeat et similique. Facilis officiis vel vel iste at consequatur.\n\nExercitationem sit quia itaque voluptatem sit ea laudantium. Quibusdam similique est itaque et quasi dicta. Eos error sint repellat nihil occaecati soluta.\n\nVoluptatem facere cumque voluptatem suscipit dolore assumenda. Suscipit corporis cum enim. Voluptas ex eligendi id et qui enim. Magnam sunt et qui. Ea error perferendis est qui.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
7	2	Eligendi qui nihil ullam repellat incidunt quos.	Blanditiis a aut cumque optio ut repellendus explicabo neque. Tenetur quo esse quia consequuntur. Nisi laudantium quia ut quasi dolorem aut eveniet. Voluptatem et quia voluptatibus.\n\nIpsam eius velit iste repellendus unde ut aut. Beatae vero dolor quia itaque fugiat facilis et doloribus. Culpa optio eius id nulla deserunt corrupti animi. Non porro quos animi.\n\nConsequatur deleniti atque porro. Occaecati magni dolores architecto labore saepe. Repellat omnis perspiciatis et veritatis nesciunt facere ea.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
8	2	Ducimus molestiae voluptatem quibusdam quis et quasi officia.	Pariatur sit optio perferendis. Ut aliquid dignissimos aut sint aut. Reiciendis fuga quia earum error accusamus impedit. Natus facere nesciunt in corrupti tempora fugiat.\n\nIure corporis error in. Dolores quis et consectetur iusto. Numquam sequi sit consectetur voluptas voluptatum possimus.\n\nAccusantium id non in pariatur totam. Recusandae est quisquam aperiam totam quas magni ut et. Nisi eius ipsum corrupti accusantium cum amet. Aut praesentium tempore sequi eaque. Tenetur laborum ex culpa et consequatur.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
9	3	Quibusdam consequatur consectetur corporis.	Rerum iusto nihil sit sunt qui fugit. Dolore maiores est distinctio.\n\nQuia officia atque error ad ea. Laudantium alias totam voluptas. Voluptate earum provident non maxime tempora voluptas ducimus.\n\nSint est recusandae voluptas hic quia consequatur. Sed suscipit nisi eligendi aspernatur molestiae et aut. Quasi alias et odio ipsa placeat labore amet. Repellat sit temporibus odio et aliquid iusto sed excepturi.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
10	3	Numquam nam voluptatem esse veniam nemo at et.	Sed voluptatem et illo corporis et eaque inventore. Esse possimus libero repellendus libero. Eaque quisquam quod rerum temporibus ipsam veniam in.\n\nPerferendis est assumenda omnis in quo excepturi. A natus odit quia facilis. Officiis architecto vel vitae nihil sunt.\n\nNumquam expedita deserunt aut illum quo totam rerum. Iste eveniet vel mollitia enim. Et et facere quidem. Tenetur et dolorum repellendus quo dolor dolores. Quas ea qui quibusdam alias modi consequatur ut.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
11	4	Voluptas et distinctio aperiam quos eligendi dolore.	Consequatur quisquam fugiat dolor aliquid. Quos labore molestias cumque voluptas eaque. Voluptas aut doloremque accusantium. Cupiditate ullam voluptates id et ullam.\n\nAut repellat et accusamus dicta. Dicta et et aliquid illo. Est quasi rerum rerum aliquid aliquam.\n\nConsequatur provident et autem omnis aut dignissimos incidunt ut. Dicta consequuntur quisquam quam nostrum dolorum magni aliquid adipisci. Similique et et eos iusto aut. Possimus voluptatem et eos qui soluta.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
12	4	Voluptatum quos repudiandae corporis laboriosam dolores sed voluptatem rem.	Pariatur eaque non dolores iure. Nihil et vitae enim rem sint.\n\nVoluptatem cupiditate tempore ea aut amet earum. A sequi architecto fuga voluptate. Recusandae labore sapiente repudiandae ducimus.\n\nQuisquam architecto deserunt tenetur ipsa eum. Quam id corrupti ipsum assumenda totam repellendus. Velit minus sunt sequi aut voluptatibus. Id eum eius sit inventore.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
13	5	Velit molestiae dolorem adipisci impedit illo nisi vel.	Aut iusto cum alias sapiente. Nostrum quaerat ipsum inventore est magnam. Mollitia facere unde aut at et sunt. Rerum quasi aut repudiandae omnis impedit voluptatem.\n\nAmet delectus eum voluptas rerum fugiat aspernatur. Sint perferendis a reiciendis adipisci dolorem beatae. Qui pariatur iusto explicabo voluptas unde est.\n\nError maxime quae est quos porro qui. Quis laudantium odit temporibus corporis explicabo aliquam expedita quis.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
14	5	Quia nisi ut sit reprehenderit qui non distinctio.	Error nihil dolorem rerum et necessitatibus veritatis porro voluptates. Aspernatur ipsum et esse inventore et repudiandae sunt. Id doloribus laboriosam expedita dolore esse.\n\nRepellat ab eius voluptas. Qui reiciendis temporibus numquam dignissimos. Quia labore eveniet voluptatem molestias. Quisquam praesentium hic nobis dignissimos qui.\n\nEos sed doloremque consequuntur neque ab quia. Natus eaque et voluptatem atque assumenda. Voluptas et ab aut sapiente temporibus non. Cupiditate et accusantium quaerat corporis non.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
15	5	Eum ab rerum est iure quia officia.	Qui nulla porro est laborum accusantium sint. Maiores perspiciatis et laudantium error. Officiis odit magni hic repellat. Ipsa est aliquid eos sequi quae fugit odio.\n\nCum et enim incidunt dignissimos earum sunt. Nesciunt sint occaecati est quo eveniet nostrum sunt. Voluptatem vero similique eius rerum omnis suscipit atque. Fugiat iste autem neque illum omnis accusamus alias voluptatem.\n\nDolorem nam impedit omnis nam aut est. Rem eaque qui deleniti ex. At magni quidem tempora quos.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
16	5	Dolore rerum provident consequatur eius ratione amet.	Amet excepturi ut consequatur eligendi ut sint. Ratione odit non eum deleniti. Sed possimus eius quisquam.\n\nEst nisi quod non quia sapiente. Totam minima deserunt repellat quos et perspiciatis. Totam earum sunt omnis ut iusto et. Voluptate qui neque id sequi.\n\nQuae sunt vel aperiam ex laudantium esse qui. Nobis explicabo qui fuga. Quam neque quas et quidem ut eum rem vero. Quae ullam quia nam itaque.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
17	6	Ducimus saepe aut occaecati facilis doloremque.	Repudiandae minus aspernatur voluptatem natus perspiciatis enim non dolor. Laudantium dolore ut necessitatibus in quis provident. Molestiae qui sed ut dolor est similique porro. Earum eos vel est corrupti.\n\nPossimus ea sint rerum vero animi quaerat quibusdam. Sed animi nostrum atque sit molestiae quaerat dolorum. Nostrum omnis dolorem temporibus voluptate rerum.\n\nVoluptatem consequatur consectetur culpa est dolore. Qui officiis excepturi explicabo eveniet placeat error aspernatur.	t	2026-03-15 15:56:52	2026-03-15 15:56:52
18	6	Sunt delectus molestiae quae suscipit.	Qui aut quo a eligendi dolorem illum excepturi beatae. Vero magni dolor accusantium veritatis dolorem sed.\n\nAut nulla ipsum eligendi debitis. Reprehenderit voluptatibus labore nisi eligendi sunt sit consequatur. Natus natus expedita beatae odio. Illum qui exercitationem qui.\n\nAut veniam reiciendis totam. Et soluta distinctio libero. Nostrum quos ea est quaerat repellat. Ullam inventore quis sed quos quasi adipisci.	f	2026-03-15 15:56:52	2026-03-15 15:56:52
\.


--
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_categories (id, organization_id, parent_id, name, code, sort_order, icon_url, created_at, updated_at, deleted_at) FROM stdin;
1	1	\N	蔬菜	VEG	1	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
2	1	\N	水果	FRT	2	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
3	1	\N	肉类	MEAT	3	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
4	1	\N	水产	SEA	4	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
5	1	\N	豆制品	TOFU	5	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
6	1	\N	干货	DRY	6	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, organization_id, category_id, name, code, barcode, brand, unit, spec, image_urls, description, shelf_life_days, storage_condition, is_fresh, min_order_qty, purchase_unit, purchase_unit_qty, status, created_by, created_at, updated_at, deleted_at, supplier_id) FROM stdin;
1	1	1	胡萝卜	\N	\N	\N	斤	\N	\N	\N	14	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
2	1	1	西兰花	\N	\N	\N	斤	\N	\N	\N	5	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
3	1	1	白菜	\N	\N	\N	斤	\N	\N	\N	7	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
4	1	1	番茄	\N	\N	\N	斤	\N	\N	\N	7	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
5	1	1	青椒	\N	\N	\N	斤	\N	\N	\N	7	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
6	1	1	土豆	\N	\N	\N	斤	\N	\N	\N	30	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
7	1	1	洋葱	\N	\N	\N	斤	\N	\N	\N	30	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
8	1	2	苹果	\N	\N	\N	斤	\N	\N	\N	14	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
9	1	2	香蕉	\N	\N	\N	斤	\N	\N	\N	5	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
10	1	2	橙子	\N	\N	\N	斤	\N	\N	\N	14	1	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	1
11	1	3	猪五花肉	\N	\N	\N	斤	\N	\N	\N	3	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	2
12	1	3	鸡胸肉	\N	\N	\N	斤	\N	\N	\N	3	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	2
13	1	3	牛腩	\N	\N	\N	斤	\N	\N	\N	3	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	2
14	1	3	猪排骨	\N	\N	\N	斤	\N	\N	\N	3	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	2
15	1	4	鲈鱼	\N	\N	\N	斤	\N	\N	\N	1	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:05	2026-03-22 08:25:36	\N	3
16	1	4	基围虾	\N	\N	\N	斤	\N	\N	\N	1	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	3
17	1	4	花蛤	\N	\N	\N	斤	\N	\N	\N	1	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	3
18	1	5	豆腐	\N	\N	\N	块	\N	\N	\N	3	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	1
19	1	5	豆芽	\N	\N	\N	斤	\N	\N	\N	2	2	t	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	1
20	1	6	大米	\N	\N	\N	斤	\N	\N	\N	365	1	f	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	1
21	1	6	食用油	\N	\N	\N	桶	\N	\N	\N	540	1	f	1.000	\N	\N	1	\N	2026-03-22 08:02:06	2026-03-22 08:25:36	\N	1
22	1	\N	龙眼	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-03-31 06:44:27	2026-03-31 06:44:27	\N	\N
23	1	\N	荔枝	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-03-31 06:44:27	2026-03-31 06:44:27	\N	\N
24	1	\N	170g炸鱼蛋	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
25	1	\N	170g墨鱼味鱼丸	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
26	1	\N	170g八爪鱼味鱼球	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
27	1	\N	170g鱼肉春卷	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
28	1	\N	170g顺德鱼腐	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
29	1	\N	170g黄金片头	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
30	1	\N	170g牛肉丸	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
31	1	\N	170g黑椒牛肉丸	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:49:29	2026-04-01 04:49:29	\N	\N
32	1	\N	野生苹果	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
33	1	\N	小台芒	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
34	1	\N	耙耙柑	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
35	1	\N	牛奶蕉	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
36	1	\N	赣南脐橙	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
37	1	\N	散装枇杷	\N	\N	\N	件	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-05-11 21:04:51	\N	\N
38	1	\N	精品草莓	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
39	1	\N	袋装金桔	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
40	1	\N	油柑	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
41	1	\N	小青橘	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
42	1	\N	带叶沃柑	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
43	1	\N	菠萝	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
44	1	\N	大木瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
45	1	\N	菠萝蜜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
46	1	\N	蓝莓	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-01 04:56:43	2026-04-01 04:56:43	\N	\N
47	1	\N	上海麵 350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
48	1	\N	拉麵 350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
49	1	\N	虾米腸粉（6條）	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
50	1	\N	白腸粉（6條）	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-05-11 21:04:20	\N	\N
51	1	\N	油麵 350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
52	1	\N	云吞麵（幼）350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
53	1	\N	云吞麵（粗）350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
54	1	\N	河粉（炒粉）350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
55	1	\N	云吞面（粗）350g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-05 05:33:08	2026-04-05 05:33:08	\N	\N
56	1	\N	野生苹果 72	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-07 01:10:59	2026-04-07 01:10:59	\N	\N
57	1	\N	鸡蛋王 (小一号)	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-07 01:10:59	2026-04-07 01:10:59	\N	\N
58	1	\N	橄榄	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-07 01:10:59	2026-04-07 01:10:59	\N	\N
59	1	\N	小木瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-07 01:10:59	2026-04-07 01:10:59	\N	\N
60	1	\N	赣南橙	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-16 12:17:46	2026-04-16 12:17:46	\N	\N
61	1	\N	散装串茄	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-16 12:17:46	2026-04-16 12:17:46	\N	\N
62	1	\N	水蜜桃	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-16 22:45:20	2026-04-16 22:45:20	\N	\N
63	1	\N	12	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-04-27 20:56:40	2026-04-27 20:56:40	\N	\N
64	1	\N	猕猴桃	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 20:00:58	2026-05-11 20:00:58	\N	\N
65	1	\N	辣椒叶300g	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:02:17	2026-05-11 21:02:17	\N	\N
66	1	\N	地瓜叶300g	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:02:17	2026-05-11 21:02:17	\N	\N
67	1	\N	黄豆芽300g	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:02:17	2026-05-11 21:02:17	\N	\N
68	1	\N	番茄(粉)350g	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:02:17	2026-05-11 21:02:17	\N	\N
69	1	\N	玉露香梨	\N	\N	\N	个	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:02:17	2026-05-11 21:02:17	\N	\N
70	1	\N	上海麵350g	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
71	1	\N	蝦米腸粉	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
72	1	\N	油麵350g	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
73	1	\N	雲吞麵 (幼) 350g	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
74	1	\N	雲吞麵 (粗) 350g	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
75	1	\N	河粉 (炒粉) 350g	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
76	1	\N	牛油果	\N	\N	\N	件	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:51	2026-05-11 21:04:51	\N	\N
77	1	\N	榴莲番薯	\N	\N	\N	件	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:51	2026-05-11 21:04:51	\N	\N
78	1	\N	奇异果	\N	\N	\N	件	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:51	2026-05-11 21:04:51	\N	\N
79	1	\N	番石榴	\N	\N	\N	件	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:04:51	2026-05-11 21:04:51	\N	\N
80	1	\N	冰鲜清远鸡	\N	\N	\N	只	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:35:31	2026-05-11 21:35:31	\N	\N
81	1	\N	冰鲜竹丝鸡	\N	\N	\N	只	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:35:31	2026-05-11 21:35:31	\N	\N
82	1	\N	娃娃菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
83	1	\N	大白菜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
84	1	\N	小旺菜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
85	1	\N	京包	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
86	1	\N	椰菜花	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
87	1	\N	西蘭花	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
88	1	\N	水東芥菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
89	1	\N	青通	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
90	1	\N	上海青苗	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
91	1	\N	菜心	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
92	1	\N	冬瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
93	1	\N	苦瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
94	1	\N	南瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
95	1	\N	西葫蘆瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
96	1	\N	茄子	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
97	1	\N	長水瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
98	1	\N	甜玉米	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
99	1	\N	白白菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
100	1	\N	荷蘭豆	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
101	1	\N	板栗肉	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
102	1	\N	甜豆(盒)	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
103	1	\N	青蘿蔔	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
104	1	\N	白蘿蔔	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
105	1	\N	泥紅蘿蔔	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
106	1	\N	紅菜頭	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
107	1	\N	鮮鐵棍淮山	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
108	1	\N	馬鈴薯	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
109	1	\N	芋頭	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
110	1	\N	綠豆芽	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
111	1	\N	黃豆芽	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
112	1	\N	鮮黑木耳	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
113	1	\N	白蘑菇	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
114	1	\N	螺絲椒	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
115	1	\N	湖南椒	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
116	1	\N	大蔥	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
117	1	\N	西芹	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
118	1	\N	韭王	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
119	1	\N	韭菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
120	1	\N	白洋蔥	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
121	1	\N	紅洋蔥	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
122	1	\N	沙律菜	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
123	1	\N	杭白菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
124	1	\N	菠菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
125	1	\N	枸杞葉	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
126	1	\N	毛瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
127	1	\N	青瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
128	1	\N	黃秋葵	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
129	1	\N	蓮藕	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
130	1	\N	小土豆	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
131	1	\N	芋仔	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
132	1	\N	金針菇	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
133	1	\N	冬菇	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
134	1	\N	杏鮑菇	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
135	1	\N	蟹味菇	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
136	1	\N	白玉菇	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
137	1	\N	水果椒	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
138	1	\N	指天椒	\N	\N	\N	盒	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
139	1	\N	三色彩椒	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
140	1	\N	生薑	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
141	1	\N	蒜頭	\N	\N	\N	袋	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
142	1	\N	芹菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
143	1	\N	紅蔥	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
144	1	\N	芫茜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
145	1	\N	真空淮山肉	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
146	1	\N	秀珍菇	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
147	1	\N	萵筍	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
148	1	\N	雞毛菜	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
149	1	\N	百合四頭	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
150	1	\N	毛豆仁	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
151	1	\N	豌豆仁	\N	\N	\N	碟	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
152	1	\N	青木瓜	\N	\N	\N	个	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
153	1	\N	人參白薯	\N	\N	\N	包	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-11 21:38:54	2026-05-11 21:38:54	\N	\N
154	1	\N	栗子	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-31 05:05:10	2026-05-31 05:05:10	\N	\N
155	1	\N	鸡肉	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-31 06:08:33	2026-05-31 06:08:33	\N	\N
156	1	\N	面包	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-05-31 06:08:33	2026-05-31 06:08:33	\N	\N
157	1	\N	豬肉100元	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
158	1	\N	清遠雞1.1-1.3KG	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
159	1	\N	地們香蕉	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
160	1	\N	黃花魚	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
161	1	\N	紅蔥(香蔥)100g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
162	1	\N	王立鯧	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
163	1	\N	散裝串茄	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
164	1	\N	榴槤番薯500g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
165	1	\N	白蝦肉200g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
166	1	\N	蒜頭220g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
167	1	\N	胡蘿蔔(紅蘿蔔)	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
168	1	\N	一字排	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
169	1	\N	小藍莓	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
170	1	\N	龍崗雞	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
171	1	\N	士多啤梨	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
172	1	\N	芭樂	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
173	1	\N	薑(生薑)300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
174	1	\N	鮮雞蛋	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
175	1	\N	唐生菜300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
176	1	\N	三黃雞	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
177	1	\N	散裝金桔	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
178	1	\N	鯇魚	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
179	1	\N	免治豬肉	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
180	1	\N	白蘑菇200g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
181	1	\N	上海青苗300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
182	1	\N	沙律菜-帶醬150g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
183	1	\N	芥蘭苗300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
184	1	\N	唐生菜苗250g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
185	1	\N	茄子(紫)	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
186	1	\N	蜜蜂橙	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
187	1	\N	青通300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
188	1	\N	芫茜70g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
189	1	\N	菠菜苗300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
190	1	\N	水果椒250g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
191	1	\N	菠蘿蜜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
192	1	\N	水果油瓜400g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
193	1	\N	檸檬	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
194	1	\N	白豆角300g	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
195	1	\N	板栗南瓜	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
196	1	\N	霖肉	\N	\N	\N	斤	\N	\N	\N	\N	1	t	1.000	\N	\N	1	\N	2026-06-03 20:45:49	2026-06-03 20:45:49	\N	\N
\.


--
-- Data for Name: promotion_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_items (id, promotion_id, product_id, original_price, promotion_price, discount_rate, ai_suggested_price, cost_price, stock_qty_at_start, target_clear_qty, actual_sold_qty, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: promotion_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_reviews (id, promotion_id, store_id, total_revenue, total_cost, gross_profit, gross_profit_rate, clear_rate, waste_amount_prevented, customer_traffic_change, ai_effectiveness_score, lessons_learned, recommendations, generated_at) FROM stdin;
\.


--
-- Data for Name: promotion_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotion_rules (id, organization_id, name, trigger_type, trigger_condition, promotion_type, pricing_strategy, max_discount_rate, apply_to, apply_target_ids, auto_execute, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.promotions (id, store_id, rule_id, name, trigger_source, status, started_at, ended_at, ai_analysis, total_sales_qty, total_sales_amount, total_saved_waste_amount, created_by, approved_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_order_items (id, purchase_order_id, product_id, ordered_qty, received_qty, unit_price, total_price, created_at, updated_at, supplier_id) FROM stdin;
1	1	1	26.200	26.200	1.2000	31.44	2026-03-22 11:24:49	2026-03-22 11:24:49	1
2	1	3	43.700	43.700	0.8000	34.96	2026-03-22 11:24:49	2026-03-22 11:24:49	1
3	1	4	22.800	22.800	2.5000	57.00	2026-03-22 11:24:49	2026-03-22 11:24:49	1
4	1	6	33.700	33.700	1.0000	33.70	2026-03-22 11:24:49	2026-03-22 11:24:49	1
5	1	11	11.500	11.500	18.0000	207.00	2026-03-22 11:24:49	2026-03-22 11:24:49	2
6	1	12	9.300	9.300	12.5000	116.25	2026-03-22 11:24:49	2026-03-22 11:24:49	2
7	1	15	6.500	6.500	28.0000	182.00	2026-03-22 11:24:49	2026-03-22 11:24:49	3
8	1	18	16.900	16.900	2.5000	42.25	2026-03-22 11:24:49	2026-03-22 11:24:49	1
9	1	19	18.700	18.700	1.8000	33.66	2026-03-22 11:24:49	2026-03-22 11:24:49	1
10	1	17	11.700	11.700	12.0000	140.40	2026-03-22 11:24:49	2026-03-22 11:24:49	3
21	3	1	34.700	34.700	1.2000	41.64	2026-03-22 11:24:49	2026-03-22 11:24:49	1
22	3	3	44.500	44.500	0.8000	35.60	2026-03-22 11:24:49	2026-03-22 11:24:49	1
23	3	4	28.900	28.900	2.5000	72.25	2026-03-22 11:24:49	2026-03-22 11:24:49	1
24	3	6	37.200	37.200	1.0000	37.20	2026-03-22 11:24:49	2026-03-22 11:24:49	1
25	3	11	10.600	10.600	18.0000	190.80	2026-03-22 11:24:49	2026-03-22 11:24:49	2
26	3	12	8.700	8.700	12.5000	108.75	2026-03-22 11:24:49	2026-03-22 11:24:49	2
27	3	15	9.800	9.800	28.0000	274.40	2026-03-22 11:24:49	2026-03-22 11:24:49	3
28	3	18	25.700	25.700	2.5000	64.25	2026-03-22 11:24:49	2026-03-22 11:24:49	1
29	3	19	24.700	24.700	1.8000	44.46	2026-03-22 11:24:49	2026-03-22 11:24:49	1
30	3	17	13.400	13.400	12.0000	160.80	2026-03-22 11:24:49	2026-03-22 11:24:49	3
31	4	1	37.400	37.400	1.2000	44.88	2026-03-22 11:24:49	2026-03-22 11:24:49	1
32	4	3	28.300	28.300	0.8000	22.64	2026-03-22 11:24:49	2026-03-22 11:24:49	1
33	4	4	20.800	20.800	2.5000	52.00	2026-03-22 11:24:49	2026-03-22 11:24:49	1
34	4	6	37.300	37.300	1.0000	37.30	2026-03-22 11:24:49	2026-03-22 11:24:49	1
35	4	11	12.100	12.100	18.0000	217.80	2026-03-22 11:24:49	2026-03-22 11:24:49	2
36	4	12	9.000	9.000	12.5000	112.50	2026-03-22 11:24:49	2026-03-22 11:24:49	2
37	4	15	7.200	7.200	28.0000	201.60	2026-03-22 11:24:49	2026-03-22 11:24:49	3
38	4	18	19.800	19.800	2.5000	49.50	2026-03-22 11:24:49	2026-03-22 11:24:49	1
39	4	10	20.900	20.900	3.8000	79.42	2026-03-22 11:24:49	2026-03-22 11:24:49	1
40	4	14	7.100	7.100	22.0000	156.20	2026-03-22 11:24:49	2026-03-22 11:24:49	2
51	6	1	22.700	22.700	1.2000	27.24	2026-03-22 11:24:49	2026-03-22 11:24:49	1
52	6	3	48.900	48.900	0.8000	39.12	2026-03-22 11:24:49	2026-03-22 11:24:49	1
53	6	4	18.000	18.000	2.5000	45.00	2026-03-22 11:24:49	2026-03-22 11:24:49	1
54	6	6	27.200	27.200	1.0000	27.20	2026-03-22 11:24:50	2026-03-22 11:24:50	1
55	6	11	13.000	13.000	18.0000	234.00	2026-03-22 11:24:50	2026-03-22 11:24:50	2
56	6	12	12.200	12.200	12.5000	152.50	2026-03-22 11:24:50	2026-03-22 11:24:50	2
57	6	15	10.400	10.400	28.0000	291.20	2026-03-22 11:24:50	2026-03-22 11:24:50	3
58	6	18	22.600	22.600	2.5000	56.50	2026-03-22 11:24:50	2026-03-22 11:24:50	1
59	6	10	12.800	12.800	3.8000	48.64	2026-03-22 11:24:50	2026-03-22 11:24:50	1
60	6	14	7.600	7.600	22.0000	167.20	2026-03-22 11:24:50	2026-03-22 11:24:50	2
61	7	1	32.500	32.500	1.2000	39.00	2026-03-22 11:24:50	2026-03-22 11:24:50	1
62	7	3	37.600	37.600	0.8000	30.08	2026-03-22 11:24:50	2026-03-22 11:24:50	1
63	7	4	21.700	21.700	2.5000	54.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
64	7	6	41.800	41.800	1.0000	41.80	2026-03-22 11:24:50	2026-03-22 11:24:50	1
65	7	11	9.600	9.600	18.0000	172.80	2026-03-22 11:24:50	2026-03-22 11:24:50	2
66	7	12	10.300	10.300	12.5000	128.75	2026-03-22 11:24:50	2026-03-22 11:24:50	2
67	7	15	8.800	8.800	28.0000	246.40	2026-03-22 11:24:50	2026-03-22 11:24:50	3
68	7	18	24.500	24.500	2.5000	61.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
69	7	7	19.800	19.800	1.5000	29.70	2026-03-22 11:24:50	2026-03-22 11:24:50	1
70	7	9	13.900	13.900	3.2000	44.48	2026-03-22 11:24:50	2026-03-22 11:24:50	1
81	9	1	36.700	36.700	1.2000	44.04	2026-03-22 11:24:50	2026-03-22 11:24:50	1
82	9	3	40.500	40.500	0.8000	32.40	2026-03-22 11:24:50	2026-03-22 11:24:50	1
83	9	4	31.700	31.700	2.5000	79.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
84	9	6	26.700	26.700	1.0000	26.70	2026-03-22 11:24:50	2026-03-22 11:24:50	1
85	9	11	8.100	8.100	18.0000	145.80	2026-03-22 11:24:50	2026-03-22 11:24:50	2
86	9	12	13.000	13.000	12.5000	162.50	2026-03-22 11:24:50	2026-03-22 11:24:50	2
87	9	15	5.800	5.800	28.0000	162.40	2026-03-22 11:24:50	2026-03-22 11:24:50	3
88	9	18	21.000	21.000	2.5000	52.50	2026-03-22 11:24:50	2026-03-22 11:24:50	1
89	9	7	16.600	16.600	1.5000	24.90	2026-03-22 11:24:50	2026-03-22 11:24:50	1
90	9	9	12.200	12.200	3.2000	39.04	2026-03-22 11:24:50	2026-03-22 11:24:50	1
91	10	1	27.400	0.000	1.2000	32.88	2026-03-22 11:24:50	2026-03-22 11:24:50	1
92	10	3	29.200	0.000	0.8000	23.36	2026-03-22 11:24:50	2026-03-22 11:24:50	1
93	10	4	27.300	0.000	2.5000	68.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
94	10	6	26.400	0.000	1.0000	26.40	2026-03-22 11:24:50	2026-03-22 11:24:50	1
95	10	11	7.000	0.000	18.0000	126.00	2026-03-22 11:24:50	2026-03-22 11:24:50	2
96	10	12	8.600	0.000	12.5000	107.50	2026-03-22 11:24:50	2026-03-22 11:24:50	2
97	10	15	9.900	0.000	28.0000	277.20	2026-03-22 11:24:50	2026-03-22 11:24:50	3
98	10	18	22.800	0.000	2.5000	57.00	2026-03-22 11:24:50	2026-03-22 11:24:50	1
99	10	5	17.700	0.000	2.8000	49.56	2026-03-22 11:24:50	2026-03-22 11:24:50	1
100	10	8	22.100	0.000	4.5000	99.45	2026-03-22 11:24:50	2026-03-22 11:24:50	1
111	12	1	36.900	0.000	1.2000	44.28	2026-03-22 11:24:50	2026-03-22 11:24:50	1
112	12	3	32.300	0.000	0.8000	25.84	2026-03-22 11:24:50	2026-03-22 11:24:50	1
113	12	4	31.900	0.000	2.5000	79.75	2026-03-22 11:24:50	2026-03-22 11:24:50	1
114	12	6	25.900	0.000	1.0000	25.90	2026-03-22 11:24:50	2026-03-22 11:24:50	1
115	12	11	9.500	0.000	18.0000	171.00	2026-03-22 11:24:50	2026-03-22 11:24:50	2
116	12	12	13.100	0.000	12.5000	163.75	2026-03-22 11:24:50	2026-03-22 11:24:50	2
117	12	15	9.700	0.000	28.0000	271.60	2026-03-22 11:24:50	2026-03-22 11:24:50	3
118	12	18	17.300	0.000	2.5000	43.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
119	12	5	14.200	0.000	2.8000	39.76	2026-03-22 11:24:50	2026-03-22 11:24:50	1
120	12	8	21.400	0.000	4.5000	96.30	2026-03-22 11:24:50	2026-03-22 11:24:50	1
121	13	1	25.400	0.000	1.2000	30.48	2026-03-22 11:24:50	2026-03-22 11:24:50	1
122	13	3	36.800	0.000	0.8000	29.44	2026-03-22 11:24:50	2026-03-22 11:24:50	1
123	13	4	31.300	0.000	2.5000	78.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
124	13	6	37.100	0.000	1.0000	37.10	2026-03-22 11:24:50	2026-03-22 11:24:50	1
125	13	11	8.400	0.000	18.0000	151.20	2026-03-22 11:24:50	2026-03-22 11:24:50	2
126	13	12	12.400	0.000	12.5000	155.00	2026-03-22 11:24:50	2026-03-22 11:24:50	2
127	13	15	7.900	0.000	28.0000	221.20	2026-03-22 11:24:50	2026-03-22 11:24:50	3
128	13	18	22.600	0.000	2.5000	56.50	2026-03-22 11:24:50	2026-03-22 11:24:50	1
129	13	2	14.300	0.000	3.5000	50.05	2026-03-22 11:24:50	2026-03-22 11:24:50	1
130	13	16	6.200	0.000	65.0000	403.00	2026-03-22 11:24:50	2026-03-22 11:24:50	3
141	15	1	33.200	0.000	1.2000	39.84	2026-03-22 11:24:50	2026-03-22 11:24:50	1
142	15	3	44.300	0.000	0.8000	35.44	2026-03-22 11:24:50	2026-03-22 11:24:50	1
143	15	4	28.000	0.000	2.5000	70.00	2026-03-22 11:24:50	2026-03-22 11:24:50	1
144	15	6	38.900	0.000	1.0000	38.90	2026-03-22 11:24:50	2026-03-22 11:24:50	1
145	15	11	10.800	0.000	18.0000	194.40	2026-03-22 11:24:50	2026-03-22 11:24:50	2
146	15	12	11.700	0.000	12.5000	146.25	2026-03-22 11:24:50	2026-03-22 11:24:50	2
147	15	15	9.000	0.000	28.0000	252.00	2026-03-22 11:24:50	2026-03-22 11:24:50	3
148	15	18	15.300	0.000	2.5000	38.25	2026-03-22 11:24:50	2026-03-22 11:24:50	1
149	15	2	15.000	0.000	3.5000	52.50	2026-03-22 11:24:50	2026-03-22 11:24:50	1
150	15	16	4.400	0.000	65.0000	286.00	2026-03-22 11:24:50	2026-03-22 11:24:50	3
178	41	32	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
179	41	33	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
180	41	34	2.000	2.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
181	41	9	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
182	41	35	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
183	41	36	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
184	41	37	2.000	2.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
185	41	38	2.000	2.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
186	41	39	2.000	2.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
187	41	40	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
188	41	41	0.500	0.500	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
189	41	42	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
190	41	43	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
191	41	44	1.000	1.000	0.0000	0.00	2026-04-01 08:46:12	2026-04-01 08:46:12	\N
192	42	24	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
193	42	25	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
194	42	26	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
195	42	27	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
196	42	28	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
197	42	29	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
198	42	30	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
199	42	31	1.000	1.000	0.0000	0.00	2026-04-01 08:47:55	2026-04-01 08:47:55	\N
200	43	47	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
201	43	48	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
202	43	49	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
203	43	50	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
204	43	51	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
205	43	52	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
206	43	53	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
207	43	54	2.000	2.000	0.0000	0.00	2026-04-04 08:09:48	2026-04-04 08:09:48	\N
208	44	56	72.000	72.000	5.0000	360.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
209	44	33	38.000	38.000	9.0000	342.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
210	44	9	26.000	26.000	6.0000	156.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
211	44	35	19.000	19.000	8.0000	152.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
212	44	37	36.000	36.000	15.0000	540.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
213	44	57	20.000	20.000	45.0000	900.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
214	44	58	20.000	20.000	12.0000	240.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
215	44	41	10.000	10.000	10.0000	100.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
216	44	59	72.000	72.000	5.0000	360.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
217	44	45	20.000	20.000	10.0000	200.00	2026-04-07 01:10:59	2026-04-07 01:10:59	\N
218	45	60	2.000	2.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
219	45	44	1.000	1.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
220	45	61	1.000	1.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
221	45	45	1.000	1.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
222	45	43	1.000	1.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
223	45	32	1.000	1.000	0.0000	0.00	2026-04-16 12:17:46	2026-04-16 12:17:46	\N
224	46	1	20.000	20.000	0.0000	0.00	2026-04-28 12:46:23	2026-04-28 12:46:23	\N
225	47	4	50.000	50.000	0.0000	0.00	2026-05-11 05:41:39	2026-05-11 05:41:39	\N
226	47	1	30.000	30.000	0.0000	0.00	2026-05-11 05:41:39	2026-05-11 05:41:39	\N
227	48	10	10.000	10.000	0.0000	0.00	2026-05-11 07:21:55	2026-05-11 07:21:55	\N
228	49	1	10.000	10.000	0.0000	0.00	2026-05-11 20:00:58	2026-05-11 20:00:58	\N
229	49	64	30.000	30.000	0.0000	0.00	2026-05-11 20:00:58	2026-05-11 20:00:58	\N
230	50	70	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
231	50	71	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
232	50	50	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
233	50	72	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
234	50	73	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
235	50	74	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
236	50	75	2.000	2.000	0.0000	0.00	2026-05-11 21:04:20	2026-05-11 21:04:20	\N
237	51	76	1.000	1.000	0.0000	0.00	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
238	51	77	1.000	1.000	0.0000	0.00	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
239	51	37	1.000	1.000	0.0000	0.00	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
240	51	78	3.000	3.000	0.0000	0.00	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
241	51	79	2.000	2.000	0.0000	0.00	2026-05-11 21:04:51	2026-05-11 21:04:51	\N
242	52	80	6.000	6.000	0.0000	0.00	2026-05-11 21:35:31	2026-05-11 21:35:31	\N
243	52	81	5.000	5.000	0.0000	0.00	2026-05-11 21:35:31	2026-05-11 21:35:31	\N
244	53	82	8.000	8.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
245	53	83	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
246	53	84	8.000	8.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
247	53	85	12.000	12.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
248	53	86	6.000	6.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
249	53	87	15.000	15.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
250	53	88	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
251	53	89	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
252	53	90	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
253	53	91	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
254	53	92	20.000	20.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
255	53	93	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
256	53	94	6.000	6.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
257	53	95	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
258	53	96	6.000	6.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
259	53	97	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
260	53	98	8.000	8.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
261	53	99	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
262	53	100	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
263	53	101	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
264	53	102	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
265	53	102	4.000	4.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
266	53	103	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
267	53	104	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
268	53	105	10.000	10.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
269	53	105	12.000	12.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
270	53	106	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
271	53	107	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
272	53	108	7.000	7.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
273	53	109	3.000	3.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
274	53	110	8.000	8.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
275	53	111	6.000	6.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
276	53	112	2.000	2.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
277	53	113	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
278	53	112	5.000	5.000	0.0000	0.00	2026-05-11 21:38:53	2026-05-11 21:38:53	\N
279	53	114	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
280	53	115	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
281	53	116	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
282	53	117	7.000	7.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
283	53	118	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
284	53	119	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
285	53	120	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
286	53	121	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
287	53	122	4.000	4.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
288	53	123	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
289	53	124	10.000	10.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
290	53	125	4.000	4.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
291	53	126	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
292	53	127	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
293	53	128	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
294	53	129	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
295	53	130	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
296	53	131	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
297	53	132	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
298	53	133	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
299	53	134	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
300	53	135	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
301	53	136	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
302	53	137	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
303	53	138	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
304	53	139	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
305	53	140	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
306	53	141	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
307	53	142	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
308	53	143	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
309	53	144	5.000	5.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
310	53	145	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
311	53	146	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
312	53	147	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
313	53	148	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
314	53	149	4.000	4.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
315	53	150	3.000	3.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
316	53	151	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
317	53	152	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
318	53	153	2.000	2.000	0.0000	0.00	2026-05-11 21:38:54	2026-05-11 21:38:54	\N
319	54	8	2.000	2.000	0.0000	0.00	2026-05-30 16:06:30	2026-05-30 16:06:30	\N
320	55	124	24.000	24.000	3.5000	84.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
321	55	1	32.000	32.000	2.0000	64.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
322	55	8	18.000	18.000	1.5000	27.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
323	55	155	12.000	12.000	6.0000	72.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
324	55	156	8.000	8.000	2.5000	20.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
325	55	57	24.000	24.000	4.0000	96.00	2026-05-31 07:32:04	2026-05-31 07:32:04	\N
326	56	8	100.000	100.000	0.0000	0.00	2026-06-12 11:46:29	2026-06-12 11:46:29	\N
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.purchase_orders (id, store_id, supplier_id, order_no, order_type, status, expected_delivery_date, actual_delivery_date, total_amount, notes, created_by, approved_by, approved_at, created_at, updated_at, deleted_at, image_paths) FROM stdin;
1	1	\N	PO-20260318-00001	2	5	2026-03-18	2026-03-18	878.66	\N	1	\N	\N	2026-03-18 07:27:00	2026-03-22 11:24:49	\N	\N
3	3	\N	PO-20260318-00003	2	5	2026-03-18	2026-03-18	1030.15	\N	1	\N	\N	2026-03-18 07:03:00	2026-03-22 11:24:49	\N	\N
4	1	\N	PO-20260319-00001	2	5	2026-03-19	2026-03-19	973.84	\N	1	\N	\N	2026-03-19 07:29:00	2026-03-22 11:24:49	\N	\N
6	3	\N	PO-20260319-00003	2	5	2026-03-19	2026-03-19	1088.60	\N	1	\N	\N	2026-03-19 07:06:00	2026-03-22 11:24:50	\N	\N
7	1	\N	PO-20260320-00001	2	5	2026-03-20	2026-03-20	848.51	\N	1	\N	\N	2026-03-20 07:05:00	2026-03-22 11:24:50	\N	\N
9	3	\N	PO-20260320-00003	2	5	2026-03-20	2026-03-20	769.53	\N	1	\N	\N	2026-03-20 07:29:00	2026-03-22 11:24:50	\N	\N
10	1	\N	PO-20260321-00001	2	4	2026-03-21	\N	867.60	\N	1	\N	\N	2026-03-21 07:17:00	2026-03-22 11:24:50	\N	\N
12	3	\N	PO-20260321-00003	2	4	2026-03-21	\N	961.43	\N	1	\N	\N	2026-03-21 07:08:00	2026-03-22 11:24:50	\N	\N
13	1	\N	PO-20260322-00001	2	1	2026-03-22	\N	1212.22	\N	1	\N	\N	2026-03-22 07:08:00	2026-03-22 11:24:50	\N	\N
15	3	\N	PO-20260322-00003	2	1	2026-03-22	\N	1153.58	\N	1	\N	\N	2026-03-22 07:12:00	2026-03-22 11:24:50	\N	\N
41	2	\N	PO-20260401-00001	1	5	2026-04-01	2026-04-01	0.00	图片录入	9	\N	\N	2026-04-01 08:46:12	2026-04-01 08:46:12	\N	\N
42	2	\N	PO-20260401-00002	1	5	2026-04-01	2026-04-01	0.00	四海环球食品 发票2603-10454	9	\N	\N	2026-04-01 08:47:55	2026-04-01 08:47:55	\N	\N
43	3	\N	PO-20260404-00001	1	5	2026-04-04	2026-04-04	0.00	图片录入	11	\N	\N	2026-04-04 08:09:48	2026-04-04 08:09:48	\N	\N
44	3	\N	PO-20260407-00001	1	5	2026-04-07	2026-04-07	3350.00	港元结算，4/5 下单，4/7 到货，水果类	11	\N	\N	2026-04-07 01:10:59	2026-04-07 01:10:59	\N	\N
45	1	\N	PO-20260416-00001	1	5	2026-04-16	2026-04-16	0.00	图片录入	10	\N	\N	2026-04-16 12:17:46	2026-04-16 12:17:46	\N	\N
46	1	\N	PO-20260428-00001	1	5	2026-04-28	2026-04-28	0.00	图片录入	13	\N	\N	2026-04-28 12:46:23	2026-04-28 12:46:23	\N	\N
47	1	\N	PO-20260511-00001	1	5	2026-05-11	2026-05-11	0.00	AI录入	12	\N	\N	2026-05-11 05:41:39	2026-05-11 05:41:39	\N	\N
48	1	\N	PO-20260511-00002	1	5	2026-05-11	2026-05-11	0.00	AI录入	12	\N	\N	2026-05-11 07:21:55	2026-05-11 07:21:55	\N	\N
49	1	\N	PO-20260511-00003	1	5	2026-05-11	2026-05-11	0.00	AI录入	13	\N	\N	2026-05-11 20:00:58	2026-05-11 20:00:58	\N	\N
50	1	\N	PO-20260511-00004	1	5	2026-05-11	2026-05-11	0.00	AI录入	12	\N	\N	2026-05-11 21:04:20	2026-05-11 21:04:20	\N	\N
51	1	\N	PO-20260511-00005	1	5	2026-05-11	2026-05-11	0.00	AI录入	12	\N	\N	2026-05-11 21:04:51	2026-05-11 21:04:51	\N	\N
52	2	\N	PO-20260511-00006	1	5	2026-05-11	2026-05-11	0.00	AI录入	1	\N	\N	2026-05-11 21:35:31	2026-05-11 21:35:31	\N	\N
53	2	\N	PO-20260511-00007	1	5	2026-05-11	2026-05-11	0.00	AI录入	1	\N	\N	2026-05-11 21:38:53	2026-05-11 21:38:53	\N	\N
54	1	\N	PO-20260530-00001	1	5	2026-05-30	2026-05-30	0.00	AI录入	12	\N	\N	2026-05-30 16:06:30	2026-05-30 16:06:30	\N	\N
55	1	\N	PO-20260531-00001	1	5	2026-05-31	2026-05-31	363.00	图片录入	12	\N	\N	2026-05-31 07:32:04	2026-05-31 07:32:04	\N	["/storage/purchase_uploads/1/2026-05-31/Nm3KE0pHKZy6VqkUeDF5jSB8aVGb37M1CqJwKpY5.png"]
56	1	\N	PO-20260612-00001	1	5	2026-06-12	2026-06-12	0.00	AI录入	12	\N	\N	2026-06-12 11:46:29	2026-06-12 11:46:29	\N	\N
\.


--
-- Data for Name: quick_action_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quick_action_items (id, quick_action_id, emoji, label, "desc", item_type, route, prompt, sort_order, created_at, updated_at) FROM stdin;
5	6	📊	每日营运概况	往日库存/进货/已售/售罄	route	/pages/report/report	\N	10	2026-05-30 15:17:16	2026-05-30 15:17:16
6	6	🚚	最近进货	进货单明细	prompt	\N	查一下最近的进货单	20	2026-05-30 15:17:16	2026-05-30 15:17:16
7	6	💡	进货建议	补货优先级	prompt	\N	给我一些进货和促销建议	30	2026-05-30 15:17:16	2026-05-30 15:17:16
8	6	📝	操作日志	今日远程指令留档	prompt	\N	看一下今天的操作日志	40	2026-05-30 15:17:16	2026-05-30 15:17:16
9	5	📊	销售统计	每日销售报表	route	/pages/report/report?path=%2Fsales-report&title=%E9%94%80%E5%94%AE%E7%BB%9F%E8%AE%A1	\N	10	2026-05-31 05:28:23	2026-05-31 05:28:23
10	5	📤	上传销售报表	拍照/相册/文件 AI 识别入库	route	/pages/sales-upload/sales-upload	\N	20	2026-05-31 05:28:23	2026-05-31 05:28:23
11	11	📋	历史进货单记录	看历史上传的单据	route	/pages/purchase-orders/purchase-orders	\N	10	2026-05-31 07:08:58	2026-05-31 07:08:58
12	11	📤	上传进货单	拍照/相册/文件 AI 识别入库	route	/pages/purchase-upload/purchase-upload	\N	20	2026-05-31 07:08:58	2026-05-31 07:08:58
45	62	📈	营业概况	今日营收与客单	prompt	\N	今天的营业概况	10	2026-06-12 05:05:50	2026-06-12 05:05:50
46	62	🔥	热销菜品	卖得最好的菜	prompt	\N	最近哪些菜品最热销	20	2026-06-12 05:05:50	2026-06-12 05:05:50
47	62	🥬	备料建议	明天备多少料	prompt	\N	明天需要备多少料	30	2026-06-12 05:05:50	2026-06-12 05:05:50
48	62	🪑	客流翻台	客流与翻台率	prompt	\N	今天客流和翻台情况	40	2026-06-12 05:05:50	2026-06-12 05:05:50
49	63	💵	今日营业额	当日营收	prompt	\N	今天营业额多少	10	2026-06-12 05:05:50	2026-06-12 05:05:50
50	63	🍽️	菜品销量	各菜销量	prompt	\N	今天各菜品卖了多少	20	2026-06-12 05:05:50	2026-06-12 05:05:50
51	63	🥬	库存备料	备料余量	prompt	\N	现在还剩多少备料	30	2026-06-12 05:05:50	2026-06-12 05:05:50
52	63	🗑️	损耗记录	报废登记	prompt	\N	记录一笔损耗	40	2026-06-12 05:05:50	2026-06-12 05:05:50
53	63	👥	会员储值	会员余额	prompt	\N	查一下会员储值情况	50	2026-06-12 05:05:50	2026-06-12 05:05:50
54	64	📈	销售概况	今日销售与件数	prompt	\N	今天的销售概况	10	2026-06-12 05:05:50	2026-06-12 05:05:50
55	64	🔥	热销款式	卖得好的款	prompt	\N	最近哪些款式卖得好	20	2026-06-12 05:05:50	2026-06-12 05:05:50
56	64	⚠️	库存预警	缺货款式	prompt	\N	哪些商品库存不足	30	2026-06-12 05:05:50	2026-06-12 05:05:50
57	64	👥	会员消费	会员消费情况	prompt	\N	会员消费情况怎么样	40	2026-06-12 05:05:50	2026-06-12 05:05:50
58	65	🆕	上新管理	登记新款	prompt	\N	帮我登记今天的上新款	10	2026-06-12 05:05:50	2026-06-12 05:05:50
59	65	📦	库存查询	当前库存	prompt	\N	查一下当前库存	20	2026-06-12 05:05:50	2026-06-12 05:05:50
60	65	💰	销售统计	今日件数	prompt	\N	今天卖了多少件	30	2026-06-12 05:05:50	2026-06-12 05:05:50
61	65	👥	会员管理	会员信息	prompt	\N	查一下会员信息	40	2026-06-12 05:05:50	2026-06-12 05:05:50
62	65	📏	尺码缺货	缺码提醒	prompt	\N	哪些尺码缺货了	50	2026-06-12 05:05:50	2026-06-12 05:05:50
63	66	📈	销售概况	今日销售额	prompt	\N	今天的销售概况	10	2026-06-12 05:05:50	2026-06-12 05:05:50
64	66	🔥	畅销商品	卖得最快的货	prompt	\N	最近哪些商品最畅销	20	2026-06-12 05:05:50	2026-06-12 05:05:50
65	66	🚚	补货建议	该补哪些货	prompt	\N	需要补哪些货	30	2026-06-12 05:05:50	2026-06-12 05:05:50
66	66	⏰	临期预警	快到期商品	prompt	\N	哪些商品临期了	40	2026-06-12 05:05:50	2026-06-12 05:05:50
67	67	🚚	进货登记	登记进货	prompt	\N	登记今天的进货	10	2026-06-12 05:05:50	2026-06-12 05:05:50
68	67	📦	库存查询	当前库存	prompt	\N	查一下当前库存	20	2026-06-12 05:05:50	2026-06-12 05:05:50
69	67	💰	销售统计	今日销售	prompt	\N	今天销售额多少	30	2026-06-12 05:05:50	2026-06-12 05:05:50
70	67	⏰	临期商品	临期提醒	prompt	\N	哪些商品快到期了	40	2026-06-12 05:05:51	2026-06-12 05:05:51
71	67	🎁	促销活动	当前促销	prompt	\N	现在有哪些促销	50	2026-06-12 05:05:51	2026-06-12 05:05:51
72	68	📈	营业概况	今日营收	prompt	\N	今天的营业概况	10	2026-06-12 05:05:51	2026-06-12 05:05:51
73	68	💆	项目排行	受欢迎的项目	prompt	\N	最近哪些项目最受欢迎	20	2026-06-12 05:05:51	2026-06-12 05:05:51
74	68	📞	客户回访	待回访客户	prompt	\N	有哪些客户需要回访	30	2026-06-12 05:05:51	2026-06-12 05:05:51
75	68	🏆	员工业绩	员工业绩排行	prompt	\N	员工业绩排行怎么样	40	2026-06-12 05:05:51	2026-06-12 05:05:51
76	69	📅	预约管理	今日预约	prompt	\N	今天有哪些预约	10	2026-06-12 05:05:51	2026-06-12 05:05:51
77	69	👥	会员管理	会员信息	prompt	\N	查一下会员信息	20	2026-06-12 05:05:51	2026-06-12 05:05:51
78	69	🧾	消费记录	今日消费	prompt	\N	今天的消费记录	30	2026-06-12 05:05:51	2026-06-12 05:05:51
79	69	🏆	员工业绩	今日业绩	prompt	\N	员工今天的业绩	40	2026-06-12 05:05:51	2026-06-12 05:05:51
80	69	💳	办卡储值	新办会员	prompt	\N	帮客户办一张会员卡	50	2026-06-12 05:05:51	2026-06-12 05:05:51
90	72	🏆	业绩概况	我的业绩	prompt	\N	我的业绩概况	10	2026-06-12 05:05:51	2026-06-12 05:05:51
91	72	🤝	待跟进客户	需跟进客户	prompt	\N	有哪些客户需要跟进	20	2026-06-12 05:05:51	2026-06-12 05:05:51
92	72	🔔	续保提醒	近期续保	prompt	\N	近期要续保的保单	30	2026-06-12 05:05:51	2026-06-12 05:05:51
93	72	💼	理赔进度	理赔汇总	prompt	\N	理赔进度汇总	40	2026-06-12 05:05:51	2026-06-12 05:05:51
94	73	📄	保单查询	查保单	prompt	\N	查一下保单	10	2026-06-12 05:05:51	2026-06-12 05:05:51
95	73	🤝	客户跟进	待跟进	prompt	\N	需要跟进哪些客户	20	2026-06-12 05:05:51	2026-06-12 05:05:51
96	73	🔔	续保提醒	待续保	prompt	\N	哪些保单要续保	30	2026-06-12 05:05:51	2026-06-12 05:05:51
97	73	🏆	业绩统计	我的业绩	prompt	\N	我的业绩统计	40	2026-06-12 05:05:51	2026-06-12 05:05:51
98	73	💼	理赔进度	理赔查询	prompt	\N	理赔进度查询	50	2026-06-12 05:05:51	2026-06-12 05:05:51
117	79	📈	销售概况	今日销售	prompt	\N	今天的销售概况	10	2026-06-12 12:16:48	2026-06-12 12:16:48
118	79	🔥	爆款商品	卖爆的商品	prompt	\N	最近哪些商品最热销	20	2026-06-12 12:16:48	2026-06-12 12:16:48
119	79	⚠️	库存预警	需补货商品	prompt	\N	哪些商品库存不足需要补货	30	2026-06-12 12:16:48	2026-06-12 12:16:48
120	79	↩️	售后情况	退款售后	prompt	\N	最近的退款和售后情况	40	2026-06-12 12:16:48	2026-06-12 12:16:48
121	80	🧾	订单管理	今日订单	prompt	\N	查一下今天的订单情况	10	2026-06-12 12:16:48	2026-06-12 12:16:48
122	80	📦	库存查询	当前库存	prompt	\N	当前各商品库存还有多少	20	2026-06-12 12:16:48	2026-06-12 12:16:48
123	80	↩️	退款处理	待处理退款	prompt	\N	有哪些退款待处理	30	2026-06-12 12:16:48	2026-06-12 12:16:48
124	80	💬	客服消息	待回复消息	prompt	\N	有哪些客服消息需要回复	40	2026-06-12 12:16:48	2026-06-12 12:16:48
125	80	📊	数据报表	经营数据	prompt	\N	最近的经营数据报表	50	2026-06-12 12:16:48	2026-06-12 12:16:48
126	81	🎙️	语音翻译	语音转文字并翻译	prompt	\N	我想翻译一段内容，请先告诉我需要翻译成哪种语言（中文/英文/日文等），然后我来提供内容。	10	2026-06-12 12:16:48	2026-06-12 12:16:48
127	81	✍️	写文案写标题	产品文案与标题	prompt	\N	请帮我写电商产品文案和标题。请告诉我：1. 产品名称；2. 主要功能特点；3. 目标受众。	20	2026-06-12 12:16:48	2026-06-12 12:16:48
128	81	📋	写五点描述	Amazon Bullet Points	prompt	\N	请帮我写Amazon产品五点描述（Five Bullet Points），要突出核心卖点。请提供产品名称和主要特点：	30	2026-06-12 12:16:48	2026-06-12 12:16:48
129	81	🎨	图片设计	产品图设计方案	prompt	\N	请帮我规划一套电商产品主图和详情图的设计方案，包括构图建议、文案布局、色彩搭配。请描述你的产品：	40	2026-06-12 12:16:48	2026-06-12 12:16:48
130	81	✅	文案纠错	拼写/语法检查	prompt	\N	请帮我检查以下文案的拼写错误和语法问题，并给出修改建议。请粘贴需要检查的内容：	50	2026-06-12 12:16:48	2026-06-12 12:16:48
131	81	🔍	单词侵权检测	词汇侵权风险分析	prompt	\N	请帮我分析以下词语/短语是否存在商标侵权风险（仅供参考，不构成法律意见）。请输入要检测的词语：	60	2026-06-12 12:16:48	2026-06-12 12:16:48
132	81	⚖️	品牌专利检测	商标品牌专利侵权	prompt	\N	请帮我分析以下品牌名称/商标/专利词是否可能存在侵权风险，并给出规避建议（仅供参考，不构成法律意见）。请输入要检测的内容：	70	2026-06-12 12:16:48	2026-06-12 12:16:48
133	82	📊	财报分析	解读上市公司财报	prompt	\N	请帮我做上市公司财报分析。请提供：公司名称或股票代码、报告期（如 2025 年报），我将从盈利能力、成长性、现金流、负债结构等维度解读。	10	2026-06-14 15:32:10	2026-06-14 15:32:10
134	82	🆕	首次覆盖报告	生成首次覆盖研报	prompt	\N	请帮我撰写一份股票首次覆盖报告（Initiation Report）。请提供：标的公司、所属行业、关注要点，我将给出投资逻辑、估值与评级建议。	20	2026-06-14 15:32:10	2026-06-14 15:32:10
135	82	🧮	DCF 估值	现金流折现建模	prompt	\N	请帮我搭建 DCF 估值模型。请提供：公司名称、近年营收/利润、增长假设、WACC（不确定可让我帮你估算）。	30	2026-06-14 15:32:10	2026-06-14 15:32:10
136	82	⚖️	可比公司分析	可比公司估值	prompt	\N	请帮我做可比公司估值分析（Comparable Companies）。请提供：标的公司与 3-5 家可比公司，我将用 P/E、EV/EBITDA 等倍数对比。	40	2026-06-14 15:32:10	2026-06-14 15:32:10
137	82	🏢	竞品分析	行业竞品对比	prompt	\N	请帮我做行业竞品分析。请提供：目标公司与主要竞争对手，我将从市场份额、产品、财务、护城河等维度对比。	50	2026-06-14 15:32:10	2026-06-14 15:32:10
138	83	📑	三表建模	三大财务报表模型	prompt	\N	请帮我搭建三大财务报表联动模型（利润表/资产负债表/现金流量表）。请提供公司近 3 年财务数据与关键假设。	10	2026-06-14 15:32:10	2026-06-14 15:32:10
139	83	💼	LBO 模型	杠杆收购建模	prompt	\N	请帮我搭建 LBO 杠杆收购模型。请提供：标的 EBITDA、收购价/估值倍数、债务结构与退出假设。	20	2026-06-14 15:32:10	2026-06-14 15:32:10
140	83	🎤	路演 PPT	估值结论转路演材料	prompt	\N	请帮我把估值分析（可比/先例交易/LBO）整理成品牌化路演 PPT 大纲。请提供：交易标的、目标受众（买方/卖方）、核心卖点。	30	2026-06-14 15:32:10	2026-06-14 15:32:10
141	83	🔍	市场洞察	客户与市场洞察	prompt	\N	请帮我做市场与客户洞察简报。请提供：目标行业或客户、关注议题（融资/并购/趋势），我将汇总要点。	40	2026-06-14 15:32:10	2026-06-14 15:32:10
142	83	🤝	交易管理	交易流程跟踪	prompt	\N	请帮我梳理一笔交易的执行流程与待办清单（尽调/估值/文件/审批）。请描述交易类型与当前阶段。	50	2026-06-14 15:32:10	2026-06-14 15:32:10
143	84	🧾	对账	基金账目对账	prompt	\N	请帮我做基金账目对账。请提供或上传两侧台账（如基金账 vs 托管账），我将逐笔比对并列出差异。	10	2026-06-14 15:32:10	2026-06-14 15:32:10
144	84	🔎	差异追踪	追踪对账差异	prompt	\N	请帮我追踪并解释对账差异。请提供差异明细，我将分类原因（时点差/金额差/漏记）并给出处理建议。	20	2026-06-14 15:32:10	2026-06-14 15:32:10
145	84	📐	NAV 核对	基金净值核对	prompt	\N	请帮我核对基金 NAV 净值。请提供：估值日、持仓估值、负债与份额，我将复核单位净值。	30	2026-06-14 15:32:10	2026-06-14 15:32:10
146	84	📅	月末结账	计提与滚动结转	prompt	\N	请帮我做月末结账。请提供本期数据，我将处理费用计提、滚动结转，并生成差异说明。	40	2026-06-14 15:32:10	2026-06-14 15:32:10
147	84	✅	LP 报表审计	分发前报表审计	prompt	\N	请帮我在分发给 LP 前审计基金报表。请上传/提供报表，我将检查勾稽关系、口径一致性与异常项。	50	2026-06-14 15:32:10	2026-06-14 15:32:10
148	84	🔬	估值复核	GP 资料包估值复核	prompt	\N	请帮我复核投资组合估值。请提供 GP 资料包/估值底稿，我将按估值模板复核并准备 LP 报告要点。	60	2026-06-14 15:32:10	2026-06-14 15:32:10
149	85	🔭	项目寻源	标的公司发现	prompt	\N	请帮我做 PE 项目寻源。请提供：目标赛道、地域、规模/阶段标准，我将筛选并描述潜在标的画像。	10	2026-06-14 15:32:10	2026-06-14 15:32:10
150	85	📇	创始人触达	触达话术与CRM	prompt	\N	请帮我准备创始人触达（Outreach）。请提供：目标公司/创始人与触达目的，我将拟定个性化触达话术。	20	2026-06-14 15:32:10	2026-06-14 15:32:10
151	85	👤	客户回顾	财富客户回顾	prompt	\N	请帮我准备一次财富管理客户回顾。请提供：客户基本情况与持仓，我将梳理回顾要点与沟通建议。	30	2026-06-14 15:32:10	2026-06-14 15:32:10
152	85	🗺️	理财规划	客户理财方案	prompt	\N	请帮我做客户理财规划。请提供：客户年龄、风险偏好、目标与可投资金额，我将给出资产配置建议。	40	2026-06-14 15:32:10	2026-06-14 15:32:10
153	85	📊	组合分析	投资组合分析	prompt	\N	请帮我分析投资组合。请提供持仓明细，我将分析配置、风险敞口与收益归因。	50	2026-06-14 15:32:10	2026-06-14 15:32:10
154	85	📝	客户报告	生成客户报告	prompt	\N	请帮我生成一份客户投资报告。请提供：报告期、组合表现与关注点，我将整理成可分发的客户报告。	60	2026-06-14 15:32:10	2026-06-14 15:32:10
155	86	🪪	KYC 解析	KYC 文件解析	prompt	\N	请帮我解析 KYC 文件并提取关键信息（主体、受益人、证件、风险标识）。请上传或粘贴文件内容。	10	2026-06-14 15:32:10	2026-06-14 15:32:10
156	86	🧰	规则评估	规则网格评估	prompt	\N	请帮我按规则网格（Rules Grid）评估一笔业务的合规性。请提供业务要素与适用规则，我将逐条评估并标出风险。	20	2026-06-14 15:32:10	2026-06-14 15:32:10
157	87	🏷️	商品标题	生成爆款标题	prompt	\N	请帮我写电商商品标题（适配淘宝/拼多多/抖音/京东）。请提供：商品名称、核心卖点、目标平台，我将给出多个高搜索权重的标题供选择。	10	2026-06-14 15:49:05	2026-06-14 15:49:05
158	87	📝	详情文案	商品详情页文案	prompt	\N	请帮我写商品详情页文案。请提供：商品名称、主要功能/材质、适用人群，我将输出卖点排布与段落文案。	20	2026-06-14 15:49:05	2026-06-14 15:49:05
159	87	💎	卖点提炼	提炼核心卖点	prompt	\N	请帮我提炼商品核心卖点。请提供商品信息，我将总结 3-5 个最能打动买家的卖点。	30	2026-06-14 15:49:05	2026-06-14 15:49:05
160	87	🎨	主图设计	主图/详情图方案	prompt	\N	请帮我规划商品主图与详情图设计方案（构图、文案、配色、卖点排版）。请描述你的商品：	40	2026-06-14 15:49:05	2026-06-14 15:49:05
161	87	🎬	短视频脚本	带货短视频脚本	prompt	\N	请帮我写一条带货短视频脚本（15-60 秒，含分镜与口播）。请提供商品与卖点：	50	2026-06-14 15:49:05	2026-06-14 15:49:05
162	87	📡	直播话术	直播带货话术	prompt	\N	请帮我写直播带货话术（含引入、卖点讲解、逼单促单）。请提供商品与优惠：	60	2026-06-14 15:49:05	2026-06-14 15:49:05
163	87	📕	种草笔记	小红书种草文案	prompt	\N	请帮我写一篇小红书种草笔记（标题+正文+话题标签）。请提供商品与使用场景：	70	2026-06-14 15:49:05	2026-06-14 15:49:05
164	87	✅	文案纠错	错别字/违禁词检查	prompt	\N	请帮我检查以下电商文案的错别字、语法和违禁词，并给出修改建议。请粘贴文案：	80	2026-06-14 15:49:05	2026-06-14 15:49:05
165	88	🔑	关键词优化	搜索 SEO 关键词	prompt	\N	请帮我优化商品的搜索关键词（标题词/属性词/长尾词）。请提供商品名称与类目，我将给出关键词建议。	10	2026-06-14 15:49:05	2026-06-14 15:49:05
166	88	🏢	竞品分析	竞品对比分析	prompt	\N	请帮我做电商竞品分析。请提供我的商品与 2-3 个竞品名称或链接，我将从价格、卖点、评价、视觉等维度对比。	20	2026-06-14 15:49:05	2026-06-14 15:49:05
167	88	🛒	选品建议	上新选品方向	prompt	\N	请帮我做选品/上新建议。请提供：经营类目、目标人群、预算，我将给出选品方向与理由。	30	2026-06-14 15:49:05	2026-06-14 15:49:05
168	88	💰	定价建议	商品定价策略	prompt	\N	请帮我制定商品定价策略。请提供：成本、竞品价格、目标利润，我将给出定价与促销价建议。	40	2026-06-14 15:49:05	2026-06-14 15:49:05
169	88	🎁	活动策划	满减/优惠券方案	prompt	\N	请帮我策划一场促销活动（满减/优惠券/限时折扣）。请提供：活动目标、商品、预算，我将给出玩法与节奏。	50	2026-06-14 15:49:05	2026-06-14 15:49:05
170	88	📣	营销文案	短信/Push/朋友圈	prompt	\N	请帮我写营销推广文案（短信/push/朋友圈）。请提供：商品、活动卖点、目标人群，我将给出多版短文案。	60	2026-06-14 15:49:05	2026-06-14 15:49:05
171	89	💬	客服回复	常见问题话术	prompt	\N	请帮我写电商客服回复话术。请描述买家的问题或场景，我将给出专业、亲和的回复模板。	10	2026-06-14 15:49:05	2026-06-14 15:49:05
172	89	😡	差评处理	中差评回复	prompt	\N	请帮我回复一条中差评并给出挽回方案。请粘贴差评内容：	20	2026-06-14 15:49:05	2026-06-14 15:49:05
173	89	⏰	催付话术	催下单/催付款	prompt	\N	请帮我写催付/催下单话术（含优惠提醒、不让人反感）。请描述商品与当前优惠：	30	2026-06-14 15:49:05	2026-06-14 15:49:05
174	89	🔁	退换货话术	退换货沟通	prompt	\N	请帮我写退换货沟通话术，既守规则又安抚情绪。请描述退换货场景：	40	2026-06-14 15:49:05	2026-06-14 15:49:05
175	89	🙏	售后安抚	安抚情绪话术	prompt	\N	请帮我写售后安抚话术（物流慢/破损/不满意等）。请描述具体情况：	50	2026-06-14 15:49:05	2026-06-14 15:49:05
176	90	📈	销售概况	今日销售	prompt	\N	今天的销售概况	10	2026-06-14 15:49:05	2026-06-14 15:49:05
177	90	🔥	爆款商品	卖爆的商品	prompt	\N	最近的爆款商品	20	2026-06-14 15:49:05	2026-06-14 15:49:05
178	90	⚠️	库存预警	需补货商品	prompt	\N	哪些商品需要补货	30	2026-06-14 15:49:05	2026-06-14 15:49:05
179	90	🧾	订单情况	今日订单	prompt	\N	查一下今天的订单情况	40	2026-06-14 15:49:05	2026-06-14 15:49:05
180	90	↩️	退款售后	退款情况	prompt	\N	最近的退款和售后情况	50	2026-06-14 15:49:05	2026-06-14 15:49:05
181	91	📋	作业指导书	SOP 生成	prompt	\N	请帮我编写标准作业指导书（SOP）。请提供：工序名称、操作步骤、设备与注意事项，我将整理成规范的作业指导文件。	10	2026-06-14 15:54:10	2026-06-14 15:54:10
182	91	⚙️	工艺参数	加工参数建议	prompt	\N	请帮我推荐加工工艺参数。请提供：材料、设备/刀具、加工类型（切削/注塑/焊接等），我将给出参数建议与注意点。	20	2026-06-14 15:54:10	2026-06-14 15:54:10
183	91	💵	报价/BOM	成本估算	prompt	\N	请帮我估算产品报价与 BOM 成本。请提供：产品规格或图纸要点、材料、批量，我将拆解材料/工时/成本。	30	2026-06-14 15:54:10	2026-06-14 15:54:10
184	91	📖	技术问答	手册规范查询	prompt	\N	请帮我解答技术/工艺问题。请描述你的问题或粘贴相关手册/规范内容：	40	2026-06-14 15:54:10	2026-06-14 15:54:10
185	91	📏	图纸解读	图纸/规格解读	prompt	\N	请帮我解读机械图纸或技术规格。请上传图纸或描述关键尺寸/公差/材料要求：	50	2026-06-14 15:54:10	2026-06-14 15:54:10
186	92	🩺	故障诊断	设备故障排查	prompt	\N	请帮我诊断设备故障。请描述：设备类型、故障现象（报警/异响/停机等）、发生场景，我将给出可能原因与排查步骤。	10	2026-06-14 15:54:10	2026-06-14 15:54:10
187	92	🗓️	保养计划	点检保养周期	prompt	\N	请帮我制定设备保养计划。请提供设备清单与运行情况，我将给出点检/保养项目与周期。	20	2026-06-14 15:54:10	2026-06-14 15:54:10
188	92	📝	点检表	日常点检表生成	prompt	\N	请帮我生成设备日常点检表。请提供设备名称与关键部位，我将输出可打印的点检清单。	30	2026-06-14 15:54:10	2026-06-14 15:54:10
189	92	🔩	备件清单	易损备件梳理	prompt	\N	请帮我梳理设备的易损件与备件清单及建议库存。请提供设备型号或类型：	40	2026-06-14 15:54:10	2026-06-14 15:54:10
190	93	📄	质检报告	检验报告生成	prompt	\N	请帮我生成质检报告。请提供：产品、检验项目与实测数据，我将整理成规范的检验报告。	10	2026-06-14 15:54:10	2026-06-14 15:54:10
191	93	🛠️	8D 报告	质量问题 8D	prompt	\N	请帮我编写 8D 报告。请描述质量问题（现象、批次、影响），我将按 8D 步骤给出分析与纠正措施。	20	2026-06-14 15:54:10	2026-06-14 15:54:10
192	93	🐟	根因分析	5Why/鱼骨分析	prompt	\N	请帮我做质量问题根因分析（5Why / 鱼骨图）。请描述问题现象，我将逐层追因并给出对策。	30	2026-06-14 15:54:10	2026-06-14 15:54:10
193	93	📉	SPC 解读	过程数据分析	prompt	\N	请帮我解读 SPC 过程控制数据。请提供测量数据或控制图描述，我将判断过程是否受控并给建议。	40	2026-06-14 15:54:10	2026-06-14 15:54:10
194	93	📞	客诉处理	客户投诉回复	prompt	\N	请帮我处理客户质量投诉。请描述客诉内容，我将给出回复话术与内部改善建议。	50	2026-06-14 15:54:10	2026-06-14 15:54:10
195	94	🦺	隐患排查	安全隐患清单	prompt	\N	请帮我做车间安全隐患排查。请描述作业区域/设备/工序，我将列出 EHS 隐患点与整改建议。	10	2026-06-14 15:54:10	2026-06-14 15:54:10
196	94	🧹	5S 改善	5S 现场改善	prompt	\N	请帮我做 5S 现场改善方案。请描述现场现状，我将给出整理/整顿/清扫/清洁/素养建议。	20	2026-06-14 15:54:10	2026-06-14 15:54:10
197	94	💡	精益改善	降本增效建议	prompt	\N	请帮我做精益改善（消除浪费）。请描述工序或现状，我将识别七大浪费并给出改善方向。	30	2026-06-14 15:54:10	2026-06-14 15:54:10
198	94	🎓	培训材料	培训/考题生成	prompt	\N	请帮我编写岗位培训材料或考试题。请提供：岗位/主题与要点，我将输出培训提纲或试题。	40	2026-06-14 15:54:10	2026-06-14 15:54:10
199	94	🚨	应急预案	应急处置预案	prompt	\N	请帮我编写应急预案（火灾/工伤/设备事故等）。请说明场景，我将给出处置流程与责任分工。	50	2026-06-14 15:54:10	2026-06-14 15:54:10
200	95	📈	生产概况	今日产量	prompt	\N	今天的生产概况	10	2026-06-14 15:54:10	2026-06-14 15:54:10
201	95	📋	订单进度	订单完成度	prompt	\N	订单完成进度如何	20	2026-06-14 15:54:10	2026-06-14 15:54:10
202	95	🧱	物料库存	物料余量	prompt	\N	物料还剩多少	30	2026-06-14 15:54:10	2026-06-14 15:54:10
203	95	⚙️	设备状态	设备运行	prompt	\N	设备运行状态怎么样	40	2026-06-14 15:54:10	2026-06-14 15:54:10
204	95	🗓️	排程计划	今日排程	prompt	\N	今天的排程计划	50	2026-06-14 15:54:10	2026-06-14 15:54:10
205	96	🔎	故障诊断	症状→原因排查	prompt	\N	请帮我诊断车辆故障。请提供：车型、故障现象（异响/抖动/无法启动/仪表报警等）、出现场景，我将给出可能原因与排查步骤。	10	2026-06-14 15:57:36	2026-06-14 15:57:36
206	96	🔢	故障码解读	OBD 故障码	prompt	\N	请帮我解读 OBD 故障码。请提供故障码（如 P0301）和车型，我将说明含义、可能原因与处理建议。	20	2026-06-14 15:57:36	2026-06-14 15:57:36
207	96	🚨	仪表灯解读	报警灯含义	prompt	\N	请帮我解读仪表盘报警灯。请描述亮起的指示灯（颜色/图标）和车型，我将说明含义与是否可继续行驶。	30	2026-06-14 15:57:36	2026-06-14 15:57:36
208	96	🔊	异响判断	异响部位定位	prompt	\N	请帮我判断车辆异响来源。请描述：异响类型（咔哒/嗡嗡/金属摩擦）、出现时机（刹车/转弯/过坎/加速），我将推断可能部位。	40	2026-06-14 15:57:36	2026-06-14 15:57:36
209	97	🛠️	维修方案	维修步骤建议	prompt	\N	请帮我制定维修方案。请提供：车型、故障部位/项目，我将给出维修步骤、需更换配件与注意事项。	10	2026-06-14 15:57:36	2026-06-14 15:57:36
210	97	🧰	保养建议	按里程保养	prompt	\N	请帮我制定保养建议。请提供：车型与当前里程，我将列出该做的保养项目（机油/三滤/刹车/正时等）。	20	2026-06-14 15:57:36	2026-06-14 15:57:36
211	97	⏱️	工时估算	维修工时难度	prompt	\N	请帮我估算维修工时。请提供维修项目与车型，我将给出参考工时与难度等级。	30	2026-06-14 15:57:36	2026-06-14 15:57:36
212	97	🔩	配件查询	配件型号规格	prompt	\N	请帮我查配件型号/规格。请提供：车型、年款、需要的部位（如刹车片/火花塞），我将给出常见规格与选购建议。	40	2026-06-14 15:57:36	2026-06-14 15:57:36
213	98	📋	维修报价	工时+配件报价	prompt	\N	请帮我做维修报价单。请提供：车型、维修项目，我将拆解工时费与配件费给出报价。	10	2026-06-14 15:57:36	2026-06-14 15:57:36
214	98	🧾	工单生成	规范维修工单	prompt	\N	请帮我生成维修工单。请提供：车牌/车型、故障描述、维修项目，我将整理成规范工单。	20	2026-06-14 15:57:36	2026-06-14 15:57:36
215	98	🎁	保养套餐	套餐方案设计	prompt	\N	请帮我设计保养/维修套餐。请提供：目标客户与车型范围、预算，我将给出套餐内容与定价建议。	30	2026-06-14 15:57:36	2026-06-14 15:57:36
216	99	💬	沟通话术	维修必要性解释	prompt	\N	请帮我写向客户解释维修必要性的话术。请描述维修项目与客户顾虑，我将给出通俗易懂、可信的解释。	10	2026-06-14 15:57:36	2026-06-14 15:57:36
217	99	💰	报价解释	解释报价构成	prompt	\N	请帮我向客户解释报价为什么是这个价。请提供报价项目，我将拆解工时/配件/原因，让客户理解。	20	2026-06-14 15:57:36	2026-06-14 15:57:36
218	99	📞	完工回访	提车/回访话术	prompt	\N	请帮我写完工提车通知与回访话术。请描述维修内容，我将给出提车通知和售后回访模板。	30	2026-06-14 15:57:36	2026-06-14 15:57:36
219	99	😡	投诉处理	客诉回复	prompt	\N	请帮我处理客户投诉（维修后仍有问题/费用争议等）。请描述投诉内容，我将给出回复话术与处理建议。	40	2026-06-14 15:57:36	2026-06-14 15:57:36
220	100	📈	今日营业	今日营收	prompt	\N	今天的营业概况	10	2026-06-14 15:57:36	2026-06-14 15:57:36
221	100	🧾	在修工单	进行中的工单	prompt	\N	查一下在修的工单	20	2026-06-14 15:57:36	2026-06-14 15:57:36
222	100	🚗	在修车辆	厂内车辆	prompt	\N	现在厂里有哪些在修车辆	30	2026-06-14 15:57:36	2026-06-14 15:57:36
223	100	🔩	配件库存	配件余量	prompt	\N	配件库存还有多少	40	2026-06-14 15:57:36	2026-06-14 15:57:36
224	100	💳	挂账记录	客户挂账	prompt	\N	查一下客户挂账情况	50	2026-06-14 15:57:36	2026-06-14 15:57:36
\.


--
-- Data for Name: quick_actions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quick_actions (id, key, emoji, label, badge, action_type, prompt, target_path, target_title, web_label, admin_only, store_id, enabled, sort_order, created_at, updated_at, industry, menu_template_id) FROM stdin;
82	finance-research	📈	投研分析	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-14 15:32:10	2026-06-14 15:32:11	finance	2
83	finance-ib	🏦	投行交易	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-14 15:32:10	2026-06-14 15:32:11	finance	2
84	finance-fundadmin	💰	基金行政	\N	menu	\N	\N	\N	\N	f	\N	t	70	2026-06-14 15:32:10	2026-06-14 15:32:11	finance	2
8	help	💡	使用说明	\N	prompt	你能帮我做什么	\N	\N	\N	f	\N	t	910	2026-05-30 15:17:16	2026-06-11 23:22:17	\N	\N
9	admin	🛠️	后台管理	\N	open	\N	/admin/sso	后台管理	\N	t	\N	t	920	2026-05-30 15:17:16	2026-06-11 23:22:17	\N	\N
85	finance-pewm	🌱	私募与财富	\N	menu	\N	\N	\N	\N	f	\N	t	80	2026-06-14 15:32:10	2026-06-14 15:32:11	finance	2
86	finance-ops	🛡️	运营合规	\N	menu	\N	\N	\N	\N	f	\N	t	90	2026-06-14 15:32:10	2026-06-14 15:32:11	finance	2
91	manufacturing-process	📐	工艺文档	\N	menu	\N	\N	\N	\N	f	\N	t	45	2026-06-14 15:54:10	2026-06-14 15:54:11	manufacturing	3
92	manufacturing-equipment	🔧	设备运维	\N	menu	\N	\N	\N	\N	f	\N	t	55	2026-06-14 15:54:10	2026-06-14 15:54:11	manufacturing	3
93	manufacturing-quality	🔍	质量管理	\N	menu	\N	\N	\N	\N	f	\N	t	65	2026-06-14 15:54:10	2026-06-14 15:54:11	manufacturing	3
94	manufacturing-safety	🛡️	安全精益	\N	menu	\N	\N	\N	\N	f	\N	t	75	2026-06-14 15:54:10	2026-06-14 15:54:11	manufacturing	3
95	manufacturing-query	📊	生产查询	\N	menu	\N	\N	\N	\N	f	\N	t	85	2026-06-14 15:54:10	2026-06-14 15:54:11	manufacturing	3
61	home	🏠	返回主页	\N	home	\N	/pages/industry/industry	\N	\N	f	\N	t	1	2026-06-12 00:18:13	2026-06-12 00:18:13	\N	\N
79	cross_border-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 12:16:48	2026-06-12 12:16:49	cross_border	11
80	cross_border-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 12:16:48	2026-06-12 12:16:49	cross_border	11
81	cross_border-aitools	🤖	AI工具	\N	menu	\N	\N	\N	\N	f	\N	t	40	2026-06-12 12:16:48	2026-06-12 12:16:49	cross_border	11
87	ecommerce-content	✍️	内容创作	\N	menu	\N	\N	\N	\N	f	\N	t	45	2026-06-14 15:49:05	2026-06-14 15:49:05	ecommerce	5
88	ecommerce-ops	📈	运营推广	\N	menu	\N	\N	\N	\N	f	\N	t	55	2026-06-14 15:49:05	2026-06-14 15:49:05	ecommerce	5
89	ecommerce-service	🛎️	客服话术	\N	menu	\N	\N	\N	\N	f	\N	t	65	2026-06-14 15:49:05	2026-06-14 15:49:05	ecommerce	5
90	ecommerce-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	75	2026-06-14 15:49:05	2026-06-14 15:49:05	ecommerce	5
96	auto_repair-diagnosis	🩺	故障诊断	\N	menu	\N	\N	\N	\N	f	\N	t	45	2026-06-14 15:57:36	2026-06-14 15:57:36	auto_repair	12
97	auto_repair-service	🔧	维修保养	\N	menu	\N	\N	\N	\N	f	\N	t	55	2026-06-14 15:57:36	2026-06-14 15:57:36	auto_repair	12
98	auto_repair-quote	💵	报价开单	\N	menu	\N	\N	\N	\N	f	\N	t	65	2026-06-14 15:57:36	2026-06-14 15:57:36	auto_repair	12
99	auto_repair-customer	🛎️	客户服务	\N	menu	\N	\N	\N	\N	f	\N	t	75	2026-06-14 15:57:36	2026-06-14 15:57:36	auto_repair	12
100	auto_repair-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	85	2026-06-14 15:57:36	2026-06-14 15:57:36	auto_repair	12
4	inventory	📦	今日库存	\N	open	\N	/inventory	今日库存	\N	f	\N	t	10	2026-05-30 15:17:16	2026-05-31 06:44:54	fresh	7
5	sales	💰	今日销售	\N	menu	\N	\N	\N	\N	f	\N	t	20	2026-05-30 15:17:16	2026-05-31 05:28:23	fresh	7
6	report	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	30	2026-05-30 15:17:16	2026-05-30 15:17:16	fresh	7
10	damage	🗑️	损耗记录	\N	route	\N	/pages/damage/damage	\N	\N	f	\N	t	25	2026-05-31 04:32:11	2026-05-31 04:32:11	fresh	7
11	purchase	🚚	进货单记录	\N	menu	\N	\N	\N	\N	f	\N	t	28	2026-05-31 07:08:58	2026-05-31 07:08:58	fresh	7
68	beauty-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 05:05:51	2026-06-12 05:05:51	beauty	4
69	beauty-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 05:05:51	2026-06-12 05:05:51	beauty	4
62	restaurant-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 05:05:50	2026-06-12 05:05:51	restaurant	6
63	restaurant-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 05:05:50	2026-06-12 05:05:51	restaurant	6
66	convenience-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 05:05:50	2026-06-12 05:05:51	convenience	9
67	convenience-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 05:05:50	2026-06-12 05:05:51	convenience	9
64	apparel-query	📊	经营查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 05:05:50	2026-06-12 05:05:51	apparel	1
65	apparel-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 05:05:50	2026-06-12 05:05:51	apparel	1
72	insurance-query	📊	业绩查询	\N	menu	\N	\N	\N	\N	f	\N	t	50	2026-06-12 05:05:51	2026-06-12 05:05:51	insurance	8
73	insurance-manage	🛠️	日常管理	\N	menu	\N	\N	\N	\N	f	\N	t	60	2026-06-12 05:05:51	2026-06-12 05:05:51	insurance	8
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.regions (id, organization_id, parent_id, name, code, manager_user_id, created_at, updated_at, deleted_at) FROM stdin;
1	1	\N	香港总区	HK	\N	2026-03-22 14:54:14	2026-03-22 14:54:14	\N
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reports (id, organization_id, store_id, report_type, title, period_start, period_end, content, data_snapshot, ai_analysis, charts_config, status, is_auto_generated, generated_by, generated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: resumes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.resumes (id, organization_id, name, phone, gender, age, districts, work_types, positions, experience_years, salary_min, salary_max, salary_unit, education, availability_date, languages, skills, raw_text, source, status, notes, created_by, created_at, updated_at, deleted_at) FROM stdin;
1	1	陈大文	91234567	1	28	["筲箕湾", "柴湾", "西湾河"]	["小时工", "兼职"]	["收银员", "理货员"]	3.0	60	75	3	2	\N	["粤语", "普通话"]	["收银", "陈列", "生鲜处理"]	\N	1	1	随时可上班，有超市工作经验	\N	2026-03-22 07:58:17	2026-03-22 07:58:17	\N
2	1	李小红	92345678	2	32	["西湾河", "鲗鱼涌", "天后"]	["全职"]	["收银员", "店务员"]	5.0	14000	16000	1	2	\N	["粤语", "普通话", "英语"]	["收银", "客服", "POS系统"]	\N	1	1	有零售管理证书	\N	2026-03-22 07:58:17	2026-03-22 07:58:17	\N
3	1	王志强	93456789	1	45	["筲箕湾", "杏花邨", "柴湾"]	["全职", "兼职"]	["生鲜切配", "仓务员"]	15.0	16000	20000	1	1	\N	["粤语"]	["生鲜处理", "刀工", "冷链管理", "叉车"]	\N	2	1	精通各类海鲜及肉类切配，有冷冻仓管理经验	\N	2026-03-22 07:58:17	2026-03-22 07:58:17	\N
4	1	张美玲	94567890	2	25	["铜锣湾", "天后", "北角"]	["兼职", "小时工"]	["收银员", "理货员"]	1.0	65	80	3	3	\N	["粤语", "普通话", "英语"]	["收银", "英语接待"]	\N	1	1	大学在读，只限周末及节假日	\N	2026-03-22 07:58:17	2026-03-22 07:58:17	\N
5	1	黄国强	95678901	1	38	["旺角", "大角咀", "深水埗"]	["全职"]	["店长", "副店长"]	12.0	22000	28000	1	3	\N	["粤语", "普通话"]	["团队管理", "库存管理", "损耗控制", "采购"]	\N	1	1	曾任超市副店长，管理15人团队	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
6	1	林翠芬	96789012	2	50	["元朗", "天水围", "屯门"]	["全职", "兼职"]	["收银员", "清洁员"]	8.0	12000	14000	1	1	\N	["粤语", "普通话"]	["收银", "清洁", "勤奋负责"]	\N	1	1	工作态度认真，不介意早班	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
7	1	吴浩明	97890123	1	22	["观塘", "牛头角", "九龙湾"]	["小时工", "兼职"]	["理货员", "仓务员"]	0.5	60	70	3	2	\N	["粤语", "普通话"]	["体力充沛", "驾驶"]	\N	2	1	刚毕业，积极学习中	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
8	1	郑月娥	98901234	2	41	["沙田", "大围", "火炭"]	["全职"]	["生鲜销售", "收银员"]	10.0	15000	18000	1	2	\N	["粤语", "普通话"]	["生鲜知识", "客户关系", "陈列"]	\N	1	1	熟悉各类蔬果生鲜，有固定客户群	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
9	1	何俊杰	99012345	1	35	["荃湾", "葵芳", "葵涌"]	["全职"]	["副店长", "收银主管"]	8.0	18000	22000	1	3	\N	["粤语", "普通话", "英语"]	["收银主管", "排班", "库存管理", "员工培训"]	\N	1	1	有连锁超市收银主管经验	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
10	1	曾丽华	90123456	2	29	["将军澳", "坑口", "宝琳"]	["全职", "兼职"]	["收银员", "理货员"]	4.0	13500	15500	1	2	\N	["粤语", "普通话"]	["收银", "理货", "快速结账"]	\N	2	1	有便利店及超市工作经验，可做早班	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
11	1	刘伟成	91239876	1	55	["深水埗", "长沙湾", "荔枝角"]	["全职", "兼职"]	["仓务员", "搬运工"]	20.0	14000	16000	1	1	\N	["粤语"]	["体力好", "驾驶货车", "叉车证"]	\N	1	1	持有叉车牌及货车驾驶执照	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
12	1	谢嘉雯	92348765	2	24	["筲箕湾", "西湾河", "柴湾"]	["小时工"]	["收银员", "理货员"]	1.0	65	75	3	3	\N	["粤语", "普通话", "英语"]	["收银", "良好服务态度"]	\N	2	1	大学毕业，只做小时工，时间灵活	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
13	1	邓家豪	93458764	1	30	["大埔", "粉岭", "上水"]	["全职"]	["生鲜切配", "生鲜销售"]	6.0	17000	20000	1	2	\N	["粤语", "普通话"]	["刀工", "海鲜处理", "肉类分切", "食品安全证书"]	\N	1	1	持有食品安全主任证书	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
14	1	梁秀珍	94568763	2	47	["元朗", "锦田", "天水围"]	["兼职", "小时工"]	["收银员", "清洁员"]	6.0	60	70	3	1	\N	["粤语"]	["收银", "清洁", "勤快"]	\N	1	1	只接受元朗区工作，下午班优先	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
15	1	陈志豪	95678762	1	27	["屯门", "青衣", "荃湾"]	["全职"]	["理货员", "仓务员"]	3.0	13000	15000	1	2	\N	["粤语", "普通话"]	["理货", "库存盘点", "WMS系统"]	\N	2	1	有物流仓库操作经验	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
16	1	胡淑芳	96788761	2	36	["铜锣湾", "湾仔", "跑马地"]	["全职", "兼职"]	["收银员", "客服"]	9.0	15000	17000	1	3	\N	["粤语", "普通话", "英语"]	["收银", "英语客服", "投诉处理"]	\N	1	1	英文流利，适合旅游区门店	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
17	1	冯志明	97898760	1	43	["柴湾", "筲箕湾", "小西湾"]	["全职"]	["生鲜切配", "店务员"]	18.0	18000	22000	1	1	\N	["粤语", "普通话"]	["生鲜全品类", "蔬果陈列", "损耗管理"]	\N	1	1	生鲜经验丰富，可带新人	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
18	1	苏嘉怡	98908759	2	21	["旺角", "油麻地", "佐敦"]	["小时工", "兼职"]	["收银员", "理货员"]	0.0	60	68	3	2	\N	["粤语", "普通话"]	["学习快", "有责任心"]	\N	2	1	无经验亦可，希望从收银员做起	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
19	1	许建国	99018758	1	52	["九龙城", "土瓜湾", "马头围"]	["全职"]	["店长", "区域督导"]	25.0	28000	35000	1	3	\N	["粤语", "普通话"]	["多店管理", "人员培训", "采购谈判", "P&L管理"]	\N	1	1	曾管理生鲜超市5间分店，熟悉连锁运营	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
20	1	罗美仪	90128757	2	33	["沙田", "马鞍山", "乌溪沙"]	["全职"]	["收银主管", "收银员"]	7.0	16000	19000	1	2	\N	["粤语", "普通话"]	["收银主管", "排班", "现金管理", "员工培训"]	\N	2	1	有超市收银组长经验，可独立管理收银团队	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
21	1	杨子龙	91237654	1	19	["筲箕湾", "柴湾", "西湾河"]	["小时工"]	["理货员", "清洁员"]	0.0	58	65	3	2	\N	["粤语", "普通话"]	["勤力", "守时"]	\N	1	1	在学生，只做周末，居住筲箕湾	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
22	1	邝淑仪	92347653	2	40	["天水围", "元朗", "屯门"]	["全职", "兼职"]	["收银员", "店务员"]	11.0	13000	15000	1	1	\N	["粤语", "普通话"]	["收银", "陈列", "熟悉新界西"]	\N	1	1	新界西居住，不愿跨区	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
23	1	谭柏林	93457652	1	26	["观塘", "秀茂坪", "蓝田"]	["全职"]	["仓务员", "理货员"]	2.0	13500	15000	1	2	\N	["粤语", "普通话"]	["仓库管理", "收发货", "ERP系统"]	\N	2	1	有冻仓经验	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
24	1	方嘉颖	94567651	2	31	["北角", "炮台山", "天后"]	["兼职", "小时工"]	["收银员", "生鲜销售"]	5.0	70	85	3	3	\N	["粤语", "普通话", "英语"]	["收银", "生鲜知识", "英语服务"]	\N	1	1	全职妈妈，只做上午班小时工	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
25	1	钟伟健	95677650	1	48	["荃湾", "青衣", "葵芳"]	["全职"]	["生鲜切配", "副店长"]	22.0	22000	26000	1	2	\N	["粤语", "普通话"]	["生鲜全品类", "团队管理", "成本控制", "HACCP"]	\N	1	1	持HACCP证书，曾任生鲜主管	\N	2026-03-22 07:58:18	2026-03-22 07:58:18	\N
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_permissions (role_id, permission_id, created_at) FROM stdin;
1	1	2026-03-22 19:50:15
1	2	2026-03-22 19:50:15
1	3	2026-03-22 19:50:15
1	4	2026-03-22 19:50:15
1	5	2026-03-22 19:50:15
1	6	2026-03-22 19:50:15
1	7	2026-03-22 19:50:15
1	8	2026-03-22 19:50:15
1	9	2026-03-22 19:50:15
1	10	2026-03-22 19:50:15
1	11	2026-03-22 19:50:15
1	12	2026-03-22 19:50:15
1	13	2026-03-22 19:50:15
1	14	2026-03-22 19:50:15
1	15	2026-03-22 19:50:15
1	16	2026-03-22 19:50:15
1	17	2026-03-22 19:50:15
1	18	2026-03-22 19:50:15
1	19	2026-03-22 19:50:15
1	20	2026-03-22 19:50:15
1	21	2026-03-22 19:50:15
1	22	2026-03-22 19:50:15
1	23	2026-03-22 19:50:15
1	24	2026-03-22 19:50:15
1	25	2026-03-22 19:50:15
1	26	2026-03-22 19:50:15
1	27	2026-03-22 19:50:15
1	28	2026-03-22 19:50:15
1	29	2026-03-22 19:50:15
1	30	2026-03-22 19:50:15
1	31	2026-03-22 19:50:15
1	32	2026-03-22 19:50:15
1	33	2026-03-22 19:50:15
1	34	2026-03-22 19:50:15
1	35	2026-03-22 19:50:15
1	36	2026-03-22 19:50:15
1	37	2026-03-22 19:50:15
1	38	2026-03-22 19:50:15
1	39	2026-03-22 19:50:15
1	40	2026-03-22 19:50:15
1	41	2026-03-22 19:50:15
1	42	2026-03-22 19:50:15
1	43	2026-03-22 19:50:15
2	1	2026-03-22 19:50:15
2	2	2026-03-22 19:50:15
2	5	2026-03-22 19:50:15
2	6	2026-03-22 19:50:15
2	7	2026-03-22 19:50:15
2	8	2026-03-22 19:50:15
2	9	2026-03-22 19:50:15
2	10	2026-03-22 19:50:15
2	11	2026-03-22 19:50:15
2	12	2026-03-22 19:50:15
2	13	2026-03-22 19:50:15
2	14	2026-03-22 19:50:15
2	15	2026-03-22 19:50:15
2	16	2026-03-22 19:50:15
2	17	2026-03-22 19:50:15
2	18	2026-03-22 19:50:15
2	23	2026-03-22 19:50:15
2	31	2026-03-22 19:50:15
2	32	2026-03-22 19:50:15
2	33	2026-03-22 19:50:15
2	34	2026-03-22 19:50:15
2	35	2026-03-22 19:50:15
3	1	2026-03-22 19:50:15
3	2	2026-03-22 19:50:15
3	3	2026-03-22 19:50:15
3	4	2026-03-22 19:50:15
3	5	2026-03-22 19:50:15
3	6	2026-03-22 19:50:15
3	7	2026-03-22 19:50:15
3	8	2026-03-22 19:50:15
3	10	2026-03-22 19:50:15
3	14	2026-03-22 19:50:15
3	18	2026-03-22 19:50:15
3	19	2026-03-22 19:50:15
3	20	2026-03-22 19:50:15
3	22	2026-03-22 19:50:15
3	24	2026-03-22 19:50:15
3	25	2026-03-22 19:50:15
3	26	2026-03-22 19:50:15
3	28	2026-03-22 19:50:15
3	29	2026-03-22 19:50:15
3	30	2026-03-22 19:50:15
3	31	2026-03-22 19:50:15
3	33	2026-03-22 19:50:15
3	34	2026-03-22 19:50:15
4	22	2026-03-22 19:50:15
4	29	2026-03-22 19:50:15
4	30	2026-03-22 19:50:15
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (id, organization_id, name, code, description, scope, created_at, updated_at) FROM stdin;
1	\N	总部总负责人	SUPER_ADMIN	全系统最高权限，全数据查看、规则配置、审批管理	1	2026-03-22 11:50:15	2026-03-22 11:50:15
2	\N	区域采购	REGION_BUYER	商品库、供应商、进货管理、结算核对、竞品数据维护	2	2026-03-22 11:50:15	2026-03-22 11:50:15
3	\N	门店店长	STORE_MANAGER	本店经营全流程操作、数据查看、调整权限、上传简历、上传支付凭证、上传竞品情报	3	2026-03-22 11:50:15	2026-03-22 11:50:15
4	\N	门店店员	STORE_STAFF	仅实况上报、票据上传权限，无核心调整权限	3	2026-03-22 11:50:15	2026-03-22 11:50:15
\.


--
-- Data for Name: saas_integrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.saas_integrations (id, organization_id, store_id, platform, app_id, app_secret, access_token, token_expires_at, webhook_url, config, status, last_sync_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: salary_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.salary_records (id, employee_id, store_id, year, month, work_days, actual_work_days, base_salary, overtime_pay, performance_bonus, sales_commission, deductions, social_insurance, income_tax, gross_salary, net_salary, payment_status, paid_at, notes, generated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sales_daily_summaries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_daily_summaries (id, store_id, product_id, sale_date, sales_qty, sales_amount, transaction_count, avg_selling_price, created_at, updated_at, pos_qty, pos_amount, supplement_qty, supplement_amount, ai_qty, ai_amount) FROM stdin;
1	1	8	2026-03-31	15.000	150.00	3	10.0000	2026-03-31 05:21:29	2026-03-31 05:21:29	0.000	0.00	0.000	0.00	0.000	0.00
2	1	1	2026-03-31	2.000	10.00	1	5.0000	2026-03-31 05:21:38	2026-03-31 05:21:38	0.000	0.00	0.000	0.00	0.000	0.00
3	2	4	2026-04-04	140.000	1020.00	6	7.2857	2026-04-04 02:44:59	2026-04-04 03:05:09	10.000	85.00	20.000	170.00	20.000	0.00
4	2	1	2026-04-04	55.000	192.50	3	3.5000	2026-04-04 02:44:59	2026-04-04 02:47:00	0.000	0.00	0.000	0.00	0.000	0.00
5	2	3	2026-04-04	10.000	20.00	1	2.0000	2026-04-04 02:47:00	2026-04-04 02:47:00	0.000	0.00	0.000	0.00	0.000	0.00
6	3	1	2026-04-04	10.000	0.00	1	0.0000	2026-04-04 07:24:08	2026-04-04 07:24:08	0.000	0.00	10.000	0.00	0.000	0.00
7	3	7	2026-04-04	66.600	0.00	1	0.0000	2026-04-04 07:25:26	2026-04-04 07:25:26	0.000	0.00	66.600	0.00	0.000	0.00
8	3	59	2026-04-07	72.000	0.00	1	0.0000	2026-04-07 06:50:56	2026-04-07 06:50:56	0.000	0.00	72.000	0.00	0.000	0.00
9	1	1	2026-04-16	100.000	0.00	1	0.0000	2026-04-16 22:44:01	2026-04-16 22:44:01	0.000	0.00	100.000	0.00	0.000	0.00
10	3	3	2026-04-16	223.900	0.00	1	0.0000	2026-04-16 23:14:36	2026-04-16 23:14:36	0.000	0.00	223.900	0.00	0.000	0.00
11	3	1	2026-04-16	134.100	0.00	1	0.0000	2026-04-16 23:19:24	2026-04-16 23:19:24	0.000	0.00	134.100	0.00	0.000	0.00
12	1	1	2026-04-27	20.000	0.00	2	0.0000	2026-04-27 20:58:36	2026-04-27 21:28:45	0.000	0.00	0.000	0.00	20.000	0.00
13	2	4	2026-04-27	10.000	0.00	1	0.0000	2026-04-27 21:56:48	2026-04-27 21:56:48	0.000	0.00	0.000	0.00	10.000	0.00
14	1	3	2026-04-27	22.600	0.00	1	0.0000	2026-04-27 22:26:23	2026-04-27 22:26:23	0.000	0.00	0.000	0.00	22.600	0.00
15	1	8	2026-04-29	20.000	0.00	1	0.0000	2026-04-29 08:19:43	2026-04-29 08:19:43	0.000	0.00	0.000	0.00	20.000	0.00
16	1	8	2026-05-11	0.000	0.00	1	\N	2026-05-11 20:28:44	2026-05-11 20:28:44	0.000	0.00	0.000	0.00	0.000	0.00
17	1	10	2026-05-11	30.900	0.00	1	0.0000	2026-05-11 20:29:08	2026-05-11 20:29:08	0.000	0.00	0.000	0.00	30.900	0.00
18	1	78	2026-05-30	1.000	0.00	1	0.0000	2026-05-30 08:10:59	2026-05-30 08:10:59	0.000	0.00	0.000	0.00	1.000	0.00
19	1	124	2026-05-31	24.000	84.00	1	3.5000	2026-05-31 06:08:33	2026-05-31 06:08:33	0.000	0.00	0.000	0.00	0.000	0.00
20	1	1	2026-05-31	32.000	64.00	1	2.0000	2026-05-31 06:08:33	2026-05-31 06:08:33	0.000	0.00	0.000	0.00	0.000	0.00
21	1	8	2026-05-31	18.000	27.00	1	1.5000	2026-05-31 06:08:33	2026-05-31 06:08:33	0.000	0.00	0.000	0.00	0.000	0.00
22	1	155	2026-05-31	12.000	72.00	1	6.0000	2026-05-31 06:08:33	2026-05-31 06:08:33	0.000	0.00	0.000	0.00	0.000	0.00
23	1	156	2026-05-31	8.000	20.00	1	2.5000	2026-05-31 06:08:34	2026-05-31 06:08:34	0.000	0.00	0.000	0.00	0.000	0.00
24	1	57	2026-05-31	24.000	96.00	1	4.0000	2026-05-31 06:08:34	2026-05-31 06:08:34	0.000	0.00	0.000	0.00	0.000	0.00
25	1	76	2026-06-03	1.000	0.00	1	0.0000	2026-06-03 20:30:47	2026-06-03 20:30:47	0.000	0.00	0.000	0.00	1.000	0.00
26	1	157	2026-06-03	77.300	7575.00	1	97.9948	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
27	1	34	2026-06-03	103.570	714.00	1	6.8939	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
28	1	158	2026-06-03	10.838	672.00	1	62.0018	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
29	1	159	2026-06-03	80.629	640.20	1	7.9401	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
30	1	160	2026-06-03	10.853	557.90	1	51.4075	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
31	1	161	2026-06-03	135.000	472.50	1	3.5000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
32	1	87	2026-06-03	37.967	466.50	1	12.2869	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
33	1	162	2026-06-03	10.517	441.70	1	41.9999	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
34	1	163	2026-06-03	21.545	430.90	1	20.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
35	1	164	2026-06-03	39.028	405.90	1	10.4003	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
36	1	165	2026-06-03	20.000	400.00	1	20.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
37	1	166	2026-06-03	44.000	396.00	1	9.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
38	1	167	2026-06-03	77.569	395.60	1	5.1000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
39	1	168	2026-06-03	5.415	389.90	1	71.9984	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
40	1	169	2026-06-03	27.692	386.00	1	13.9392	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
41	1	170	2026-06-03	7.000	364.00	1	52.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
42	1	171	2026-06-03	11.280	350.00	1	31.0284	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
43	1	172	2026-06-03	54.285	345.00	1	6.3554	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
44	1	173	2026-06-03	33.000	343.20	1	10.4000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
45	1	174	2026-06-03	18.000	324.00	1	18.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
46	1	93	2026-06-03	23.609	318.40	1	13.4866	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
47	1	175	2026-06-03	54.464	315.90	1	5.8001	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
48	1	176	2026-06-03	6.500	312.00	1	48.0015	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
49	1	177	2026-06-03	51.285	303.70	1	5.9219	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
50	1	178	2026-06-03	7.185	287.40	1	40.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
51	1	179	2026-06-03	4.929	285.90	1	58.0013	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
52	1	127	2026-06-03	31.445	284.20	1	9.0381	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
53	1	180	2026-06-03	30.608	281.60	1	9.2002	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
54	1	181	2026-06-03	37.699	279.80	1	7.4220	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
55	1	182	2026-06-03	25.701	267.30	1	10.4003	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
56	1	183	2026-06-03	31.551	260.70	1	8.2628	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
57	1	184	2026-06-03	28.084	253.50	1	9.0267	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
58	1	185	2026-06-03	30.420	253.00	1	8.3170	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
59	1	186	2026-06-03	41.668	250.00	1	5.9999	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
60	1	108	2026-06-03	42.266	248.00	1	5.8676	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
61	1	109	2026-06-03	18.913	238.30	1	12.6000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
62	1	120	2026-06-03	47.280	236.40	1	5.0000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
63	1	187	2026-06-03	34.590	227.50	1	6.5771	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
64	1	68	2026-06-03	35.000	227.50	1	6.5000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
65	1	188	2026-06-03	65.000	227.50	1	3.5000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
66	1	189	2026-06-03	21.429	225.00	1	10.4998	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
67	1	190	2026-06-03	17.307	225.00	1	13.0005	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
68	1	191	2026-06-03	16.086	220.00	1	13.6765	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
69	1	192	2026-06-03	24.717	218.60	1	8.8441	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
70	1	193	2026-06-03	86.400	216.00	1	2.5000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
71	1	194	2026-06-03	25.608	210.00	1	8.2004	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
72	1	44	2026-06-03	27.668	210.00	1	7.5899	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
73	1	85	2026-06-03	49.429	207.60	1	4.2000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
74	1	195	2026-06-03	24.058	206.90	1	8.6000	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
75	1	196	2026-06-03	3.002	204.10	1	67.9993	2026-06-03 20:45:49	2026-06-03 20:45:49	0.000	0.00	0.000	0.00	0.000	0.00
\.


--
-- Data for Name: sales_order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_order_items (id, sales_order_id, product_id, qty, unit_price, discount_amount, subtotal, cost_price, created_at, updated_at) FROM stdin;
1	1	8	10.000	10.00	0.00	100.00	\N	2026-03-31 05:21:29	2026-03-31 05:21:29
2	2	8	5.000	10.00	0.00	50.00	\N	2026-03-31 05:21:29	2026-03-31 05:21:29
3	3	1	2.000	5.00	0.00	10.00	\N	2026-03-31 05:21:38	2026-03-31 05:21:38
4	4	4	30.000	8.50	0.00	255.00	\N	2026-04-04 02:44:59	2026-04-04 02:44:59
5	5	1	15.000	3.50	0.00	52.50	\N	2026-04-04 02:44:59	2026-04-04 02:44:59
6	6	4	30.000	8.50	0.00	255.00	\N	2026-04-04 02:45:37	2026-04-04 02:45:37
7	7	1	15.000	3.50	0.00	52.50	\N	2026-04-04 02:45:37	2026-04-04 02:45:37
8	8	4	30.000	8.50	0.00	255.00	\N	2026-04-04 02:47:00	2026-04-04 02:47:00
9	9	1	25.000	3.50	0.00	87.50	\N	2026-04-04 02:47:00	2026-04-04 02:47:00
10	10	3	10.000	2.00	0.00	20.00	\N	2026-04-04 02:47:00	2026-04-04 02:47:00
11	11	1	10.000	0.00	0.00	0.00	\N	2026-04-04 07:24:08	2026-04-04 07:24:08
12	12	7	66.600	0.00	0.00	0.00	\N	2026-04-04 07:25:26	2026-04-04 07:25:26
13	13	59	72.000	0.00	0.00	0.00	\N	2026-04-07 06:50:56	2026-04-07 06:50:56
14	14	1	100.000	0.00	0.00	0.00	\N	2026-04-16 22:44:01	2026-04-16 22:44:01
15	15	3	223.900	0.00	0.00	0.00	\N	2026-04-16 23:14:36	2026-04-16 23:14:36
16	16	1	134.100	0.00	0.00	0.00	\N	2026-04-16 23:19:24	2026-04-16 23:19:24
17	17	1	10.000	0.00	0.00	0.00	\N	2026-04-27 20:58:36	2026-04-27 20:58:36
18	18	1	10.000	0.00	0.00	0.00	\N	2026-04-27 21:28:45	2026-04-27 21:28:45
19	19	4	10.000	0.00	0.00	0.00	\N	2026-04-27 21:56:48	2026-04-27 21:56:48
20	20	3	22.600	0.00	0.00	0.00	\N	2026-04-27 22:26:23	2026-04-27 22:26:23
21	21	8	20.000	0.00	0.00	0.00	\N	2026-04-29 08:19:43	2026-04-29 08:19:43
22	22	10	30.900	0.00	0.00	0.00	\N	2026-05-11 20:29:08	2026-05-11 20:29:08
23	23	78	1.000	0.00	0.00	0.00	\N	2026-05-30 08:10:59	2026-05-30 08:10:59
24	24	124	24.000	3.50	0.00	84.00	\N	2026-05-31 06:08:33	2026-05-31 06:08:33
25	25	1	32.000	2.00	0.00	64.00	\N	2026-05-31 06:08:33	2026-05-31 06:08:33
26	26	8	18.000	1.50	0.00	27.00	\N	2026-05-31 06:08:33	2026-05-31 06:08:33
27	27	155	12.000	6.00	0.00	72.00	\N	2026-05-31 06:08:33	2026-05-31 06:08:33
28	28	156	8.000	2.50	0.00	20.00	\N	2026-05-31 06:08:34	2026-05-31 06:08:34
29	29	57	24.000	4.00	0.00	96.00	\N	2026-05-31 06:08:34	2026-05-31 06:08:34
30	30	76	1.000	0.00	0.00	0.00	\N	2026-06-03 20:30:47	2026-06-03 20:30:47
31	31	157	77.300	97.99	0.00	7575.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
32	32	34	103.570	6.89	0.00	714.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
33	33	158	10.838	62.00	0.00	672.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
34	34	159	80.629	7.94	0.00	640.20	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
35	35	160	10.853	51.41	0.00	557.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
36	36	161	135.000	3.50	0.00	472.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
37	37	87	37.967	12.29	0.00	466.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
38	38	162	10.517	42.00	0.00	441.70	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
39	39	163	21.545	20.00	0.00	430.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
40	40	164	39.028	10.40	0.00	405.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
41	41	165	20.000	20.00	0.00	400.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
42	42	166	44.000	9.00	0.00	396.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
43	43	167	77.569	5.10	0.00	395.60	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
44	44	168	5.415	72.00	0.00	389.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
45	45	169	27.692	13.94	0.00	386.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
46	46	170	7.000	52.00	0.00	364.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
47	47	171	11.280	31.03	0.00	350.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
48	48	172	54.285	6.36	0.00	345.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
49	49	173	33.000	10.40	0.00	343.20	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
50	50	174	18.000	18.00	0.00	324.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
51	51	93	23.609	13.49	0.00	318.40	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
52	52	175	54.464	5.80	0.00	315.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
53	53	176	6.500	48.00	0.00	312.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
54	54	177	51.285	5.92	0.00	303.70	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
55	55	178	7.185	40.00	0.00	287.40	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
56	56	179	4.929	58.00	0.00	285.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
57	57	127	31.445	9.04	0.00	284.20	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
58	58	180	30.608	9.20	0.00	281.60	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
59	59	181	37.699	7.42	0.00	279.80	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
60	60	182	25.701	10.40	0.00	267.30	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
61	61	183	31.551	8.26	0.00	260.70	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
62	62	184	28.084	9.03	0.00	253.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
63	63	185	30.420	8.32	0.00	253.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
64	64	186	41.668	6.00	0.00	250.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
65	65	108	42.266	5.87	0.00	248.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
66	66	109	18.913	12.60	0.00	238.30	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
67	67	120	47.280	5.00	0.00	236.40	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
68	68	187	34.590	6.58	0.00	227.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
69	69	68	35.000	6.50	0.00	227.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
70	70	188	65.000	3.50	0.00	227.50	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
71	71	189	21.429	10.50	0.00	225.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
72	72	190	17.307	13.00	0.00	225.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
73	73	191	16.086	13.68	0.00	220.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
74	74	192	24.717	8.84	0.00	218.60	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
75	75	193	86.400	2.50	0.00	216.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
76	76	194	25.608	8.20	0.00	210.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
77	77	44	27.668	7.59	0.00	210.00	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
78	78	85	49.429	4.20	0.00	207.60	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
79	79	195	24.058	8.60	0.00	206.90	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
80	80	196	3.002	68.00	0.00	204.10	\N	2026-06-03 20:45:49	2026-06-03 20:45:49
\.


--
-- Data for Name: sales_orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_orders (id, store_id, order_no, cashier_id, total_amount, discount_amount, paid_amount, payment_method, status, sold_at, notes, created_at, updated_at, deleted_at) FROM stdin;
1	1	ADJ-20260331-AFZYOQ	\N	100.00	0.00	100.00	1	1	2026-03-31 05:21:29	[远程补录] 测试售罄	2026-03-31 05:21:29	2026-03-31 05:21:29	\N
2	1	ADJ-20260331-EFYYOA	\N	50.00	0.00	50.00	1	1	2026-03-31 05:21:29	[远程补录] 测试补录	2026-03-31 05:21:29	2026-03-31 05:21:29	\N
3	1	SO-20260331-KMSOZX	1	10.00	0.00	10.00	2	1	2026-03-31 05:21:38	\N	2026-03-31 05:21:38	2026-03-31 05:21:38	\N
4	2	ADJ-20260404-B9AQ3L	\N	255.00	0.00	255.00	1	1	2026-04-04 02:44:59	[远程补录] 售罄补录	2026-04-04 02:44:59	2026-04-04 02:44:59	\N
5	2	ADJ-20260404-YFMMN8	\N	52.50	0.00	52.50	1	1	2026-04-04 02:44:59	[远程补录] 售罄补录	2026-04-04 02:44:59	2026-04-04 02:44:59	\N
6	2	ADJ-20260404-UOS1IT	\N	255.00	0.00	255.00	1	1	2026-04-04 02:45:37	[远程补录] 售罄补录	2026-04-04 02:45:37	2026-04-04 02:45:37	\N
7	2	ADJ-20260404-UQQSZ2	\N	52.50	0.00	52.50	1	1	2026-04-04 02:45:37	[远程补录] 售罄补录	2026-04-04 02:45:37	2026-04-04 02:45:37	\N
8	2	SUP-20260404-JNPA7O	\N	255.00	0.00	255.00	1	1	2026-04-04 02:47:00	[补录] sold_out	2026-04-04 02:47:00	2026-04-04 02:47:00	\N
9	2	SUP-20260404-KF7MRN	\N	87.50	0.00	87.50	1	1	2026-04-04 02:47:00	[补录] remaining	2026-04-04 02:47:00	2026-04-04 02:47:00	\N
10	2	SUP-20260404-A7MBLF	\N	20.00	0.00	20.00	1	1	2026-04-04 02:47:00	[补录] qty	2026-04-04 02:47:00	2026-04-04 02:47:00	\N
11	3	SUP-20260404-YK4DKY	\N	0.00	0.00	0.00	1	1	2026-04-04 07:24:08	[补录] qty	2026-04-04 07:24:08	2026-04-04 07:24:08	\N
12	3	SUP-20260404-KOBRME	\N	0.00	0.00	0.00	1	1	2026-04-04 07:25:26	[补录] sold_out	2026-04-04 07:25:26	2026-04-04 07:25:26	\N
13	3	SUP-20260407-LVG0QB	\N	0.00	0.00	0.00	1	1	2026-04-07 06:50:00	[补录] sold_out	2026-04-07 06:50:56	2026-04-07 06:50:56	\N
14	1	SUP-20260416-G0KRQL	\N	0.00	0.00	0.00	1	1	2026-04-16 16:00:00	[补录] sold_out	2026-04-16 22:44:01	2026-04-16 22:44:01	\N
15	3	SUP-20260416-I8YRLP	\N	0.00	0.00	0.00	1	1	2026-04-16 23:14:36	[补录] sold_out	2026-04-16 23:14:36	2026-04-16 23:14:36	\N
16	3	SUP-20260416-HZ5KWM	\N	0.00	0.00	0.00	1	1	2026-04-16 23:19:24	[补录] remaining	2026-04-16 23:19:24	2026-04-16 23:19:24	\N
17	1	AI-20260427-JWB61H	\N	0.00	0.00	0.00	1	1	2026-04-27 20:58:36	[AI录入] 胡萝卜	2026-04-27 20:58:36	2026-04-27 20:58:36	\N
18	1	AI-20260427-HQF1VX	\N	0.00	0.00	0.00	1	1	2026-04-27 21:28:45	[AI录入] 胡萝卜	2026-04-27 21:28:45	2026-04-27 21:28:45	\N
19	2	AI-20260427-GJ48FE	\N	0.00	0.00	0.00	1	1	2026-04-27 21:56:48	[AI录入] 番茄	2026-04-27 21:56:48	2026-04-27 21:56:48	\N
20	1	AI-20260427-DVDQYG	\N	0.00	0.00	0.00	1	1	2026-04-27 22:26:23	[AI录入] 白菜	2026-04-27 22:26:23	2026-04-27 22:26:23	\N
21	1	AI-20260429-4QBYLY	\N	0.00	0.00	0.00	1	1	2026-04-29 08:19:43	[AI录入] 苹果	2026-04-29 08:19:43	2026-04-29 08:19:43	\N
22	1	AI-20260511-9RLPF6	\N	0.00	0.00	0.00	1	1	2026-05-11 20:29:08	[AI录入] 橙子	2026-05-11 20:29:08	2026-05-11 20:29:08	\N
23	1	AI-20260530-MKT4OW	\N	0.00	0.00	0.00	1	1	2026-05-30 08:10:59	[AI录入] 奇异果	2026-05-30 08:10:59	2026-05-30 08:10:59	\N
24	1	UPL-20260531-TZOG67	\N	84.00	0.00	84.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33	2026-05-31 06:08:33	\N
25	1	UPL-20260531-O6S25E	\N	64.00	0.00	64.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33	2026-05-31 06:08:33	\N
26	1	UPL-20260531-EGG8V8	\N	27.00	0.00	27.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33	2026-05-31 06:08:33	\N
27	1	UPL-20260531-92DM70	\N	72.00	0.00	72.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33	2026-05-31 06:08:33	\N
28	1	UPL-20260531-VHDK4J	\N	20.00	0.00	20.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:33	2026-05-31 06:08:33	\N
29	1	UPL-20260531-YSGDNX	\N	96.00	0.00	96.00	1	1	2026-05-31 06:08:33	[销售上传] gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31 06:08:34	2026-05-31 06:08:34	\N
30	1	AI-20260603-1J34WF	\N	0.00	0.00	0.00	1	1	2026-06-03 20:30:47	[AI录入] 牛油果	2026-06-03 20:30:47	2026-06-03 20:30:47	\N
31	1	UPL-20260603-6Q2RHP	\N	7575.00	0.00	7575.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
32	1	UPL-20260603-0B8QSV	\N	714.00	0.00	714.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
33	1	UPL-20260603-G9OP3W	\N	672.00	0.00	672.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
34	1	UPL-20260603-CCGAPX	\N	640.20	0.00	640.20	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
35	1	UPL-20260603-SPKE7S	\N	557.90	0.00	557.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
36	1	UPL-20260603-TXFYH9	\N	472.50	0.00	472.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
37	1	UPL-20260603-A2NXQ1	\N	466.50	0.00	466.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
38	1	UPL-20260603-MFTJOA	\N	441.70	0.00	441.70	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
39	1	UPL-20260603-PU5S8C	\N	430.90	0.00	430.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
40	1	UPL-20260603-INSAL9	\N	405.90	0.00	405.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
41	1	UPL-20260603-ISOOUD	\N	400.00	0.00	400.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
42	1	UPL-20260603-HY1QNH	\N	396.00	0.00	396.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
43	1	UPL-20260603-BSDJBX	\N	395.60	0.00	395.60	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
44	1	UPL-20260603-VZTNKT	\N	389.90	0.00	389.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
45	1	UPL-20260603-7CXZCT	\N	386.00	0.00	386.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
46	1	UPL-20260603-32N64Q	\N	364.00	0.00	364.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
47	1	UPL-20260603-KBUDS4	\N	350.00	0.00	350.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
48	1	UPL-20260603-F4PLKW	\N	345.00	0.00	345.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
49	1	UPL-20260603-3I7HIK	\N	343.20	0.00	343.20	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
50	1	UPL-20260603-LJA8VC	\N	324.00	0.00	324.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
51	1	UPL-20260603-UGXQZF	\N	318.40	0.00	318.40	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
52	1	UPL-20260603-7CZNYB	\N	315.90	0.00	315.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
53	1	UPL-20260603-SJMHQR	\N	312.00	0.00	312.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
54	1	UPL-20260603-EDCPLV	\N	303.70	0.00	303.70	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
55	1	UPL-20260603-Q0P8HL	\N	287.40	0.00	287.40	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
56	1	UPL-20260603-IP4O6Q	\N	285.90	0.00	285.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
57	1	UPL-20260603-1FR8CK	\N	284.20	0.00	284.20	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
58	1	UPL-20260603-JLDUCS	\N	281.60	0.00	281.60	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
59	1	UPL-20260603-OOZU8W	\N	279.80	0.00	279.80	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
60	1	UPL-20260603-QRQFBX	\N	267.30	0.00	267.30	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
61	1	UPL-20260603-NYSARQ	\N	260.70	0.00	260.70	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
62	1	UPL-20260603-DG19T5	\N	253.50	0.00	253.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
63	1	UPL-20260603-DJGKBT	\N	253.00	0.00	253.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
64	1	UPL-20260603-KVJZKV	\N	250.00	0.00	250.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
65	1	UPL-20260603-THJKPP	\N	248.00	0.00	248.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
66	1	UPL-20260603-5RRMMK	\N	238.30	0.00	238.30	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
67	1	UPL-20260603-9BSLQD	\N	236.40	0.00	236.40	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
68	1	UPL-20260603-XZSZJK	\N	227.50	0.00	227.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
69	1	UPL-20260603-WIUEEY	\N	227.50	0.00	227.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
70	1	UPL-20260603-CYFSLM	\N	227.50	0.00	227.50	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
71	1	UPL-20260603-FHAOAL	\N	225.00	0.00	225.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
72	1	UPL-20260603-AFDFII	\N	225.00	0.00	225.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
73	1	UPL-20260603-BKQH2P	\N	220.00	0.00	220.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
74	1	UPL-20260603-P2ULQO	\N	218.60	0.00	218.60	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
75	1	UPL-20260603-NU0VNJ	\N	216.00	0.00	216.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
76	1	UPL-20260603-YTTOQ5	\N	210.00	0.00	210.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
77	1	UPL-20260603-VXCEXZ	\N	210.00	0.00	210.00	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
78	1	UPL-20260603-TVNE34	\N	207.60	0.00	207.60	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
79	1	UPL-20260603-UPKR2Y	\N	206.90	0.00	206.90	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
80	1	UPL-20260603-3KFXA9	\N	204.10	0.00	204.10	1	1	2026-06-03 20:45:49	[销售上传] 零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03 20:45:49	2026-06-03 20:45:49	\N
\.


--
-- Data for Name: sales_uploads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sales_uploads (id, store_id, uploaded_by, original_filename, file_path, sale_date, status, total_items, processed_items, failed_items, error_message, raw_rows, ai_result, created_at, updated_at) FROM stdin;
1	2	8	零售报表分析-零售-零售汇总_1774399133339.xlsx	sales_uploads/2/20260331_220435_零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-03-31	3	237	0	0	AI未能识别有效销售数据：AI分析失败	[{"单价": "97.9948", "商品": "豬肉100元", "序号": "1", "数量": "77.3", "笔数": "87", "金额": "7575", "兑换金额": "0", "商品编号": "10000"}, {"单价": "6.8939", "商品": "耙耙柑", "序号": "2", "数量": "103.5702", "笔数": "29", "金额": "714", "兑换金额": "0", "商品编号": "00195"}, {"单价": "62.0018000000000029", "商品": "清遠雞1.1-1.3KG", "序号": "3", "数量": "10.8384", "笔数": "7", "金额": "672", "兑换金额": "0", "商品编号": "00173"}, {"单价": "7.9401", "商品": "地們香蕉", "序号": "4", "数量": "80.629", "笔数": "50", "金额": "640.20000000000005", "兑换金额": "0", "商品编号": "00129"}, {"单价": "51.4075", "商品": "黃花魚", "序号": "5", "数量": "10.8525", "笔数": "18", "金额": "557.89999999999998", "兑换金额": "0", "商品编号": "00223"}, {"单价": "3.5", "商品": "紅蔥(香蔥)100g", "序号": "6", "数量": "135", "笔数": "104", "金额": "472.5", "兑换金额": "0", "商品编号": "00306"}, {"单价": "12.2869", "商品": "西蘭花", "序号": "7", "数量": "37.9673", "笔数": "80", "金额": "466.5", "兑换金额": "0", "商品编号": "00012"}, {"单价": "41.9999", "商品": "王立鯧", "序号": "8", "数量": "10.5167", "笔数": "16", "金额": "441.69999999999999", "兑换金额": "0", "商品编号": "00224"}, {"单价": "20", "商品": "散裝串茄", "序号": "9", "数量": "21.545", "笔数": "15", "金额": "430.89999999999998", "兑换金额": "0", "商品编号": "00654"}, {"单价": "10.4003", "商品": "榴槤番薯500g", "序号": "10", "数量": "39.027900000000002", "笔数": "35", "金额": "405.89999999999998", "兑换金额": "0", "商品编号": "00391"}, {"单价": "20", "商品": "白蝦肉200g", "序号": "11", "数量": "20", "笔数": "17", "金额": "400", "兑换金额": "0", "商品编号": "00154"}, {"单价": "9", "商品": "蒜頭220g", "序号": "12", "数量": "44", "笔数": "38", "金额": "396", "兑换金额": "0", "商品编号": "00117"}, {"单价": "5.1", "商品": "胡蘿蔔(紅蘿蔔)", "序号": "13", "数量": "77.56870000000001", "笔数": "78", "金额": "395.60000000000002", "兑换金额": "0", "商品编号": "00047"}, {"单价": "71.9984", "商品": "一字排", "序号": "14", "数量": "5.4154", "笔数": "6", "金额": "389.89999999999998", "兑换金额": "0", "商品编号": "00282"}, {"单价": "13.9392", "商品": "小藍莓", "序号": "15", "数量": "27.6916", "笔数": "15", "金额": "386", "兑换金额": "0", "商品编号": "00467"}, {"单价": "52", "商品": "龍崗雞", "序号": "16", "数量": "7", "笔数": "6", "金额": "364", "兑换金额": "0", "商品编号": "00649"}, {"单价": "31.028400000000001", "商品": "士多啤梨", "序号": "17", "数量": "11.28", "笔数": "10", "金额": "350", "兑换金额": "0", "商品编号": "00404"}, {"单价": "6.3554", "商品": "芭樂", "序号": "18", "数量": "54.2846", "笔数": "19", "金额": "345", "兑换金额": "0", "商品编号": "00410"}, {"单价": "10.4", "商品": "薑(生薑)300g", "序号": "19", "数量": "33", "笔数": "33", "金额": "343.19999999999999", "兑换金额": "0", "商品编号": "00116"}, {"单价": "18", "商品": "鮮雞蛋", "序号": "20", "数量": "18", "笔数": "16", "金额": "324", "兑换金额": "0", "商品编号": "00566"}, {"单价": "13.4866", "商品": "苦瓜", "序号": "21", "数量": "23.6087", "笔数": "55", "金额": "318.39999999999998", "兑换金额": "0", "商品编号": "00025"}, {"单价": "5.8001", "商品": "唐生菜300g", "序号": "22", "数量": "54.4644", "笔数": "66", "金额": "315.89999999999998", "兑换金额": "0", "商品编号": "00079"}, {"单价": "48.0015000000000001", "商品": "三黃雞", "序号": "23", "数量": "6.4998", "笔数": "6", "金额": "312", "兑换金额": "0", "商品编号": "00648"}, {"单价": "5.9219", "商品": "散裝金桔", "序号": "24", "数量": "51.2846", "笔数": "31", "金额": "303.69999999999999", "兑换金额": "0", "商品编号": "00652"}, {"单价": "40", "商品": "鯇魚", "序号": "25", "数量": "7.185", "笔数": "8", "金额": "287.39999999999998", "兑换金额": "0", "商品编号": "00210"}, {"单价": "58.0013000000000005", "商品": "免治豬肉", "序号": "26", "数量": "4.9292", "笔数": "9", "金额": "285.89999999999998", "兑换金额": "0", "商品编号": "00281"}, {"单价": "9.0381", "商品": "青瓜", "序号": "27", "数量": "31.4448", "笔数": "34", "金额": "284.19999999999999", "兑换金额": "0", "商品编号": "00084"}, {"单价": "9.2002", "商品": "白蘑菇200g", "序号": "28", "数量": "30.608", "笔数": "25", "金额": "281.60000000000002", "兑换金额": "0", "商品编号": "00061"}, {"单价": "7.422", "商品": "上海青苗300g", "序号": "29", "数量": "37.6985", "笔数": "37", "金额": "279.80000000000001", "兑换金额": "0", "商品编号": "00019"}, {"单价": "10.4003", "商品": "沙律菜-帶醬150g", "序号": "30", "数量": "25.7013", "笔数": "24", "金额": "267.30000000000001", "兑换金额": "0", "商品编号": "00075"}, {"单价": "8.2628", "商品": "芥蘭苗300g", "序号": "31", "数量": "31.551", "笔数": "28", "金额": "260.69999999999999", "兑换金额": "0", "商品编号": "00014"}, {"单价": "9.0267", "商品": "唐生菜苗250g", "序号": "32", "数量": "28.083500000000001", "笔数": "36", "金额": "253.5", "兑换金额": "0", "商品编号": "00303"}, {"单价": "8.317", "商品": "茄子(紫)", "序号": "33", "数量": "30.4197", "笔数": "48", "金额": "253", "兑换金额": "0", "商品编号": "00029"}, {"单价": "5.9999", "商品": "蜜蜂橙", "序号": "34", "数量": "41.6675", "笔数": "21", "金额": "250", "兑换金额": "0", "商品编号": "00399"}, {"单价": "5.8676", "商品": "馬鈴薯", "序号": "35", "数量": "42.2657", "笔数": "37", "金额": "248", "兑换金额": "0", "商品编号": "00051"}, {"单价": "12.6", "商品": "芋頭", "序号": "36", "数量": "18.9127", "笔数": "20", "金额": "238.30000000000001", "兑换金额": "0", "商品编号": "00052"}, {"单价": "5", "商品": "白洋蔥", "序号": "37", "数量": "47.28", "笔数": "49", "金额": "236.40000000000001", "兑换金额": "0", "商品编号": "00073"}, {"单价": "6.5771", "商品": "青通300g", "序号": "38", "数量": "34.5896", "笔数": "31", "金额": "227.5", "兑换金额": "0", "商品编号": "00017"}, {"单价": "6.5", "商品": "番茄(粉)350g", "序号": "39", "数量": "35", "笔数": "30", "金额": "227.5", "兑换金额": "0", "商品编号": "00030"}, {"单价": "3.5", "商品": "芫茜70g", "序号": "40", "数量": "65", "笔数": "53", "金额": "227.5", "兑换金额": "0", "商品编号": "00307"}, {"单价": "10.4998", "商品": "菠菜苗300g", "序号": "41", "数量": "21.429", "笔数": "28", "金额": "225", "兑换金额": "0", "商品编号": "00006"}, {"单价": "13.00050000000000061", "商品": "水果椒250g", "序号": "42", "数量": "17.307", "笔数": "18", "金额": "225", "兑换金额": "0", "商品编号": "00107"}, {"单价": "13.6765", "商品": "菠蘿蜜", "序号": "43", "数量": "16.085999999999999", "笔数": "14", "金额": "220", "兑换金额": "0", "商品编号": "00462"}, {"单价": "8.8441", "商品": "水果油瓜400g", "序号": "44", "数量": "24.717", "笔数": "26", "金额": "218.59999999999999", "兑换金额": "0", "商品编号": "00266"}, {"单价": "2.5", "商品": "檸檬", "序号": "45", "数量": "86.40000000000001", "笔数": "16", "金额": "216", "兑换金额": "0", "商品编号": "00446"}, {"单价": "8.2004", "商品": "白豆角300g", "序号": "46", "数量": "25.6084", "笔数": "28", "金额": "210", "兑换金额": "0", "商品编号": "00036"}, {"单价": "7.5899", "商品": "木瓜", "序号": "47", "数量": "27.6684", "笔数": "17", "金额": "210", "兑换金额": "0", "商品编号": "00193"}, {"单价": "4.2", "商品": "京包", "序号": "48", "数量": "49.4286", "笔数": "30", "金额": "207.59999999999999", "兑换金额": "0", "商品编号": "00007"}, {"单价": "8.6", "商品": "板栗南瓜", "序号": "49", "数量": "24.0581", "笔数": "14", "金额": "206.90000000000001", "兑换金额": "0", "商品编号": "00086"}, {"单价": "67.99930000000001", "商品": "霖肉", "序号": "50", "数量": "3.0015000000000001", "笔数": "5", "金额": "204.099999999999994", "兑换金额": "0", "商品编号": "00280"}, {"单价": "25", "商品": "日本白蛋10只", "序号": "51", "数量": "8", "笔数": "8", "金额": "200", "兑换金额": "0", "商品编号": "00217"}, {"单价": "6.1", "商品": "聖女果300g", "序号": "52", "数量": "32.4588", "笔数": "31", "金额": "198", "兑换金额": "0", "商品编号": "00392"}, {"单价": "9", "商品": "大牛油果", "序号": "53", "数量": "21.4445", "笔数": "6", "金额": "193", "兑换金额": "0", "商品编号": "00486"}, {"单价": "6.6003", "商品": "番茄350g", "序号": "54", "数量": "29.1655", "笔数": "31", "金额": "192.5", "兑换金额": "0", "商品编号": "00089"}, {"单价": "9.1429", "商品": "鹽水花生", "序号": "55", "数量": "21", "笔数": "17", "金额": "192", "兑换金额": "0", "商品编号": "00470"}, {"单价": "7.6729", "商品": "菜心苗300g", "序号": "56", "数量": "24.7625", "笔数": "17", "金额": "190", "兑换金额": "0", "商品编号": "00022"}, {"单价": "41.9998", "商品": "沙鑽魚", "序号": "57", "数量": "4.4905", "笔数": "8", "金额": "188.59999999999999", "兑换金额": "0", "商品编号": "00668"}, {"单价": "17.2993", "商品": "串茄198g", "序号": "58", "数量": "10.8097", "笔数": "10", "金额": "187", "兑换金额": "0", "商品编号": "00309"}, {"单价": "9", "商品": "牛奶蕉", "序号": "59", "数量": "20.3445", "笔数": "13", "金额": "183.099999999999994", "兑换金额": "0", "商品编号": "00468"}, {"单价": "34.9994", "商品": "豬潤", "序号": "60", "数量": "5.1258", "笔数": "10", "金额": "179.40000000000001", "兑换金额": "0", "商品编号": "00268"}, {"单价": "72.00060000000000571", "商品": "文昌雞1.1-1.3KG", "序号": "61", "数量": "2.4722", "笔数": "2", "金额": "178", "兑换金额": "0", "商品编号": "00319"}, {"单价": "7.5", "商品": "辣椒(杭椒)250g", "序号": "62", "数量": "23", "笔数": "16", "金额": "172.5", "兑换金额": "0", "商品编号": "00111"}, {"单价": "6.9526", "商品": "上海青300g", "序号": "63", "数量": "24.6814", "笔数": "33", "金额": "171.59999999999999", "兑换金额": "0", "商品编号": "00018"}, {"单价": "40", "商品": "大頭魚", "序号": "64", "数量": "4.27", "笔数": "5", "金额": "170.80000000000001", "兑换金额": "0", "商品编号": "00289"}, {"单价": "8.8999", "商品": "玉米(甜)", "序号": "65", "数量": "18.899", "笔数": "26", "金额": "168.19999999999999", "兑换金额": "0", "商品编号": "00033"}, {"单价": "4.1001", "商品": "小土豆400g", "序号": "66", "数量": "40.9016", "笔数": "31", "金额": "167.69999999999999", "兑换金额": "0", "商品编号": "00096"}, {"单价": "16.5998", "商品": "三色彩椒550g", "序号": "67", "数量": "9.8736", "笔数": "11", "金额": "163.90000000000001", "兑换金额": "0", "商品编号": "00112"}, {"单价": "23.2558", "商品": "蘆筍200g", "序号": "68", "数量": "6.88", "笔数": "10", "金额": "160", "兑换金额": "0", "商品编号": "00050"}, {"单价": "7.3968", "商品": "黄秋葵200g", "序号": "69", "数量": "20.8198", "笔数": "20", "金额": "154", "兑换金额": "0", "商品编号": "00088"}, {"单价": "7", "商品": "百福蒸煮豆腐350ml/盒", "序号": "70", "数量": "22", "笔数": "19", "金额": "154", "兑换金额": "0", "商品编号": "00189"}, {"单价": "9.4999", "商品": "油麥菜苗250g", "序号": "71", "数量": "15.9159", "笔数": "20", "金额": "151.19999999999999", "兑换金额": "0", "商品编号": "00304"}, {"单价": "5.9", "商品": "地瓜葉300g", "序号": "72", "数量": "25.1694", "笔数": "24", "金额": "148.5", "兑换金额": "0", "商品编号": "00077"}, {"单价": "52.014699999999998", "商品": "肉眼（肉扒）", "序号": "73", "数量": "2.8242", "笔数": "4", "金额": "146.90000000000001", "兑换金额": "0", "商品编号": "00273"}, {"单价": "9.5004", "商品": "大紅椒250g", "序号": "74", "数量": "15.2099", "笔数": "4", "金额": "144.5", "兑换金额": "0", "商品编号": "00109"}, {"单价": "12.6004", "商品": "甜豆300g", "序号": "75", "数量": "11.4282", "笔数": "17", "金额": "144", "兑换金额": "0", "商品编号": "00039"}, {"单价": "37.9987", "商品": "竹絲雞（小 ）0.9-1.0KG", "序号": "76", "数量": "3.7896", "笔数": "4", "金额": "144", "兑换金额": "0", "商品编号": "00316"}, {"单价": "12", "商品": "菠蘿", "序号": "77", "数量": "12", "笔数": "12", "金额": "144", "兑换金额": "0", "商品编号": "00439"}, {"单价": "4.1002", "商品": "珠蔥150g", "序号": "78", "数量": "34.2914", "笔数": "31", "金额": "140.59999999999999", "兑换金额": "0", "商品编号": "00067"}, {"单价": "8.2997", "商品": "娃娃菜（三個装）", "序号": "79", "数量": "16.868", "笔数": "20", "金额": "140", "兑换金额": "0", "商品编号": "00001"}, {"单价": "4.4", "商品": "冬瓜", "序号": "80", "数量": "31.7046", "笔数": "22", "金额": "139.5", "兑换金额": "0", "商品编号": "00023"}, {"单价": "29.9996", "商品": "星鱸", "序号": "81", "数量": "4.6434", "笔数": "5", "金额": "139.30000000000001", "兑换金额": "0", "商品编号": "00226"}, {"单价": "5.7999", "商品": "湖南椒250g", "序号": "82", "数量": "23.7075", "笔数": "16", "金额": "137.5", "兑换金额": "0", "商品编号": "00065"}, {"单价": "8.5", "商品": "豆蔔1份", "序号": "83", "数量": "16", "笔数": "15", "金额": "136", "兑换金额": "0", "商品编号": "00194"}, {"单价": "6.8", "商品": "攸縣香干200g/袋", "序号": "84", "数量": "20", "笔数": "20", "金额": "136", "兑换金额": "0", "商品编号": "00342"}, {"单价": "20.3191", "商品": "枇杷", "序号": "85", "数量": "6.644", "笔数": "6", "金额": "135", "兑换金额": "0", "商品编号": "00395"}, {"单价": "8.9002", "商品": "荷蘭豆200g", "序号": "86", "数量": "14.9435", "笔数": "16", "金额": "133", "兑换金额": "0", "商品编号": "00037"}, {"单价": "13.9374", "商品": "鮮淮山", "序号": "87", "数量": "9.5355", "笔数": "9", "金额": "132.90000000000001", "兑换金额": "0", "商品编号": "00095"}, {"单价": "8.1843", "商品": "菜心300g", "序号": "88", "数量": "15.8841", "笔数": "15", "金额": "130", "兑换金额": "0", "商品编号": "00021"}, {"单价": "12.2002", "商品": "板栗肉200g", "序号": "89", "数量": "10.6392", "笔数": "11", "金额": "129.80000000000001", "兑换金额": "0", "商品编号": "00038"}, {"单价": "10.887", "商品": "福建花(散花）", "序号": "90", "数量": "11.7204", "笔数": "14", "金额": "127.59999999999999", "兑换金额": "0", "商品编号": "00386"}, {"单价": "25", "商品": "羅非魚", "序号": "91", "数量": "5.084", "笔数": "6", "金额": "127.099999999999994", "兑换金额": "0", "商品编号": "00292"}, {"单价": "7.0001", "商品": "指天椒100g", "序号": "92", "数量": "18.071100000000001", "笔数": "22", "金额": "126.5", "兑换金额": "0", "商品编号": "00108"}, {"单价": "3.4001", "商品": "金針菇200g", "序号": "93", "数量": "36.8808", "笔数": "24", "金额": "125.40000000000001", "兑换金额": "0", "商品编号": "00100"}, {"单价": "7.8", "商品": "南瓜(貝貝南瓜)", "序号": "94", "数量": "15.8206", "笔数": "16", "金额": "123.40000000000001", "兑换金额": "0", "商品编号": "00085"}, {"单价": "7.7", "商品": "西芹", "序号": "95", "数量": "15.7012", "笔数": "30", "金额": "120.90000000000001", "兑换金额": "0", "商品编号": "00069"}, {"单价": "103.4808", "商品": "梅頭瘦肉", "序号": "96", "数量": "1.1664", "笔数": "3", "金额": "120.7", "兑换金额": "0", "商品编号": "00283"}, {"单价": "5.1", "商品": "辣椒(螺絲椒)250g", "序号": "97", "数量": "23.5296", "笔数": "15", "金额": "120", "兑换金额": "0", "商品编号": "00064"}, {"单价": "4.0998", "商品": "綠豆芽300g", "序号": "98", "数量": "29.0258", "笔数": "31", "金额": "119", "兑换金额": "0", "商品编号": "00055"}, {"单价": "9.1649", "商品": "學鬥白菜300g", "序号": "99", "数量": "12.9298", "笔数": "14", "金额": "118.5", "兑换金额": "0", "商品编号": "00390"}, {"单价": "49.1776", "商品": "白倉魚", "序号": "100", "数量": "2.4015", "笔数": "4", "金额": "118.099999999999994", "兑换金额": "0", "商品编号": "00667"}, {"单价": "4.3607", "商品": "白蘿蔔", "序号": "101", "数量": "26.4864", "笔数": "23", "金额": "115.5", "兑换金额": "0", "商品编号": "00045"}, {"单价": "9.8995", "商品": "大蔥", "序号": "102", "数量": "11.6066", "笔数": "16", "金额": "114.90000000000001", "兑换金额": "0", "商品编号": "00068"}, {"单价": "8.6348", "商品": "毛瓜", "序号": "103", "数量": "13.0518", "笔数": "16", "金额": "112.7", "兑换金额": "0", "商品编号": "00083"}, {"单价": "11.2999", "商品": "毛豆500g", "序号": "104", "数量": "9.9558", "笔数": "8", "金额": "112.5", "兑换金额": "0", "商品编号": "00092"}, {"单价": "5", "商品": "小旺菜", "序号": "105", "数量": "22.46", "笔数": "17", "金额": "112.3", "兑换金额": "0", "商品编号": "00004"}, {"单价": "3.9205", "商品": "木耳200g", "序号": "106", "数量": "27.8536", "笔数": "3", "金额": "109.2", "兑换金额": "0", "商品编号": "00062"}, {"单价": "10.7001", "商品": "四季豆450g", "序号": "107", "数量": "9.813", "笔数": "10", "金额": "105", "兑换金额": "0", "商品编号": "00034"}, {"单价": "7.8997", "商品": "冬菇200g", "序号": "108", "数量": "13.2916", "笔数": "13", "金额": "105", "兑换金额": "0", "商品编号": "00101"}, {"单价": "10.6003", "商品": "馬蹄500g", "序号": "109", "数量": "9.8582", "笔数": "11", "金额": "104.5", "兑换金额": "0", "商品编号": "00041"}, {"单价": "7.1", "商品": "紅菜頭", "序号": "110", "数量": "14.6901", "笔数": "14", "金额": "104.3", "兑换金额": "0", "商品编号": "00048"}, {"单价": "60.4825", "商品": "五花腩", "序号": "111", "数量": "1.7162", "笔数": "2", "金额": "103.8", "兑换金额": "0", "商品编号": "00284"}, {"单价": "13.6999", "商品": "粉葛", "序号": "112", "数量": "7.5037", "笔数": "6", "金额": "102.8", "兑换金额": "0", "商品编号": "00060"}, {"单价": "10.3352", "商品": "椰菜花(白花菜)", "序号": "113", "数量": "9.9369", "笔数": "10", "金额": "102.7", "兑换金额": "0", "商品编号": "00011"}, {"单价": "5.8", "商品": "胡蘿蔔(泥紅蘿蔔)", "序号": "114", "数量": "17.1379", "笔数": "27", "金额": "99.40000000000001", "兑换金额": "0", "商品编号": "00046"}, {"单价": "8.8999", "商品": "糖心蜜薯", "序号": "115", "数量": "10.9327", "笔数": "10", "金额": "97.3", "兑换金额": "0", "商品编号": "00093"}, {"单价": "97.9996", "商品": "飛排", "序号": "116", "数量": "0.9898", "笔数": "2", "金额": "97", "兑换金额": "0", "商品编号": "00279"}, {"单价": "8", "商品": "百福硬豆腐340g/盒", "序号": "117", "数量": "12", "笔数": "8", "金额": "96", "兑换金额": "0", "商品编号": "00188"}, {"单价": "7.9", "商品": "小咖啡菇200g", "序号": "118", "数量": "12", "笔数": "11", "金额": "94.8", "兑换金额": "0", "商品编号": "00118"}, {"单价": "6.2971", "商品": "油麥菜300g", "序号": "119", "数量": "14.864", "笔数": "18", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00020"}, {"单价": "8.7957", "商品": "秀珍菇150g", "序号": "120", "数量": "10.6416", "笔数": "11", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00322"}, {"单价": "8.2996", "商品": "毛豆仁200g", "序号": "121", "数量": "11.2776", "笔数": "9", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00372"}, {"单价": "8.5", "商品": "上海水餃皮（白圓皮）350g", "序号": "122", "数量": "11", "笔数": "9", "金额": "93.5", "兑换金额": "0", "商品编号": "00206"}, {"单价": "8.5", "商品": "長水瓜", "序号": "123", "数量": "10.8353", "笔数": "13", "金额": "92.099999999999994", "兑换金额": "0", "商品编号": "00031"}, {"单价": "88.0031000000000034", "商品": "豬展", "序号": "124", "数量": "1.0261", "笔数": "3", "金额": "90.3", "兑换金额": "0", "商品编号": "00263"}, {"单价": "7.5679", "商品": "雞毛菜300g", "序号": "125", "数量": "11.8924", "笔数": "7", "金额": "90", "兑换金额": "0", "商品编号": "00327"}, {"单价": "10.5", "商品": "蓮藕", "序号": "126", "数量": "8.4095", "笔数": "9", "金额": "88.3", "兑换金额": "0", "商品编号": "00094"}, {"单价": "13.0063999999999993", "商品": "鮮鐵棍淮山", "序号": "127", "数量": "6.7582", "笔数": "8", "金额": "87.90000000000001", "兑换金额": "0", "商品编号": "00049"}, {"单价": "3.5999", "商品": "芹菜150g", "序号": "128", "数量": "23.334", "笔数": "23", "金额": "84", "兑换金额": "0", "商品编号": "00119"}, {"单价": "42", "商品": "豬肚（個）", "序号": "129", "数量": "2", "笔数": "2", "金额": "84", "兑换金额": "0", "商品编号": "00251"}, {"单价": "12", "商品": "鵪鶉蛋", "序号": "130", "数量": "7", "笔数": "7", "金额": "84", "兑换金额": "0", "商品编号": "00564"}, {"单价": "5.8", "商品": "洋蔥(紅)", "序号": "131", "数量": "14.2759", "笔数": "15", "金额": "82.8", "兑换金额": "0", "商品编号": "00074"}, {"单价": "77.99939999999999", "商品": "排骨頭", "序号": "132", "数量": "1.0577", "笔数": "1", "金额": "82.5", "兑换金额": "0", "商品编号": "00260"}, {"单价": "7.5131", "商品": "萵筍", "序号": "133", "数量": "10.9409", "笔数": "14", "金额": "82.2", "兑换金额": "0", "商品编号": "00325"}, {"单价": "6.0001", "商品": "富士苹果", "序号": "134", "数量": "13.3332", "笔数": "3", "金额": "80", "兑换金额": "0", "商品编号": "00427"}, {"单价": "12.2033", "商品": "金奇異果", "序号": "135", "数量": "6.5556", "笔数": "2", "金额": "80", "兑换金额": "0", "商品编号": "00556"}, {"单价": "6.4869", "商品": "韭王150g", "序号": "136", "数量": "12.0243", "笔数": "11", "金额": "78", "兑换金额": "0", "商品编号": "00070"}, {"单价": "12.6", "商品": "百合四頭", "序号": "137", "数量": "6", "笔数": "6", "金额": "75.59999999999999", "兑换金额": "0", "商品编号": "00362"}, {"单价": "5.4999", "商品": "羽衣甘藍150g", "序号": "138", "数量": "13.6365", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00009"}, {"单价": "9.2891", "商品": "茼蒿300g", "序号": "139", "数量": "8.074", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00401"}, {"单价": "62.003300000000003", "商品": "西施", "序号": "140", "数量": "1.208", "笔数": "2", "金额": "74.90000000000001", "兑换金额": "0", "商品编号": "00287"}, {"单价": "4.7", "商品": "大白菜", "序号": "141", "数量": "15.4682", "笔数": "8", "金额": "72.7", "兑换金额": "0", "商品编号": "00003"}, {"单价": "8", "商品": "佛手瓜", "序号": "142", "数量": "9.0375", "笔数": "12", "金额": "72.3", "兑换金额": "0", "商品编号": "00040"}, {"单价": "4.8", "商品": "杭白菜300g", "序号": "143", "数量": "15", "笔数": "1", "金额": "72", "兑换金额": "0", "商品编号": "00076"}, {"单价": "9", "商品": "鹹蛋4只", "序号": "144", "数量": "8", "笔数": "8", "金额": "72", "兑换金额": "0", "商品编号": "00147"}, {"单价": "8.2996", "商品": "豌豆仁200g", "序号": "145", "数量": "8.4582", "笔数": "9", "金额": "70.2", "兑换金额": "0", "商品编号": "00373"}, {"单价": "9.2998", "商品": "真空淮山肉300g", "序号": "146", "数量": "7.312", "笔数": "7", "金额": "68", "兑换金额": "0", "商品编号": "00312"}, {"单价": "6.7", "商品": "攸縣白干200g/袋", "序号": "147", "数量": "10", "笔数": "8", "金额": "67", "兑换金额": "0", "商品编号": "00341"}, {"单价": "7.6", "商品": "紫椰菜", "序号": "148", "数量": "8.6316", "笔数": "6", "金额": "65.59999999999999", "兑换金额": "0", "商品编号": "00008"}, {"单价": "48.3619", "商品": "豬展骨", "序号": "149", "数量": "1.3461", "笔数": "2", "金额": "65.099999999999994", "兑换金额": "0", "商品编号": "00246"}, {"单价": "11.522", "商品": "皇帝菜苗300g", "序号": "150", "数量": "5.6414", "笔数": "9", "金额": "65", "兑换金额": "0", "商品编号": "00324"}, {"单价": "6.1001", "商品": "芋仔300g", "序号": "151", "数量": "10.6392", "笔数": "8", "金额": "64.90000000000001", "兑换金额": "0", "商品编号": "00097"}, {"单价": "9.2", "商品": "玉米筍200g", "序号": "152", "数量": "7", "笔数": "7", "金额": "64.40000000000001", "兑换金额": "0", "商品编号": "00032"}, {"单价": "8.9004", "商品": "紫薯500g", "序号": "153", "数量": "7.1008", "笔数": "8", "金额": "63.2", "兑换金额": "0", "商品编号": "00387"}, {"单价": "7.9", "商品": "人參白薯", "序号": "154", "数量": "8", "笔数": "6", "金额": "63.2", "兑换金额": "0", "商品编号": "00497"}, {"单价": "61.9996", "商品": "脊骨", "序号": "155", "数量": "0.9742", "笔数": "1", "金额": "60.4", "兑换金额": "0", "商品编号": "00264"}, {"单价": "10.4004", "商品": "鮮蘑菇(咖啡菇)200g", "序号": "156", "数量": "5.769", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00105"}, {"单价": "5.9999", "商品": "沙糖桔", "序号": "157", "数量": "10.00019999999999953", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00369"}, {"单价": "2.5", "商品": "百香果", "序号": "158", "数量": "24", "笔数": "2", "金额": "60", "兑换金额": "0", "商品编号": "00443"}, {"单价": "14.9993", "商品": "油柑", "序号": "159", "数量": "4.00020000000000042", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00494"}, {"单价": "11.9995", "商品": "小青瓜400g", "序号": "160", "数量": "4.7502", "笔数": "6", "金额": "57", "兑换金额": "0", "商品编号": "00024"}, {"单价": "8", "商品": "河粉（炒粉）350g", "序号": "161", "数量": "7", "笔数": "6", "金额": "56", "兑换金额": "0", "商品编号": "00212"}, {"单价": "6.3", "商品": "西葫蘆瓜", "序号": "162", "数量": "8.8413", "笔数": "6", "金额": "55.7", "兑换金额": "0", "商品编号": "00028"}, {"单价": "4.4", "商品": "南瓜", "序号": "163", "数量": "12.3864", "笔数": "12", "金额": "54.5", "兑换金额": "0", "商品编号": "00026"}, {"单价": "5.8", "商品": "杏鮑菇200g", "序号": "164", "数量": "9", "笔数": "9", "金额": "52.2", "兑换金额": "0", "商品编号": "00102"}, {"单价": "9.7998", "商品": "糯粟米", "序号": "165", "数量": "5.296", "笔数": "5", "金额": "51.9", "兑换金额": "0", "商品编号": "00091"}, {"单价": "8.5", "商品": "上海麵350g", "序号": "166", "数量": "6", "笔数": "5", "金额": "51", "兑换金额": "0", "商品编号": "00148"}, {"单价": "27.9996", "商品": "包魚骨", "序号": "167", "数量": "1.8036", "笔数": "2", "金额": "50.5", "兑换金额": "0", "商品编号": "00254"}, {"单价": "8.7997", "商品": "西洋菜300g", "序号": "168", "数量": "5.682", "笔数": "7", "金额": "50", "兑换金额": "0", "商品编号": "00323"}, {"单价": "8.3", "商品": "花生(鮮)300g", "序号": "169", "数量": "6", "笔数": "4", "金额": "49.8", "兑换金额": "0", "商品编号": "00321"}, {"单价": "16.5", "商品": "金裝牛肉丸250g/包", "序号": "170", "数量": "3", "笔数": "3", "金额": "49.5", "兑换金额": "0", "商品编号": "00296"}, {"单价": "9.9", "商品": "一點紅番薯", "序号": "171", "数量": "5", "笔数": "5", "金额": "49.5", "兑换金额": "0", "商品编号": "00656"}, {"单价": "7.6747", "商品": "芥蘭300g", "序号": "172", "数量": "6.2022", "笔数": "6", "金额": "47.6", "兑换金额": "0", "商品编号": "00015"}, {"单价": "5", "商品": "青尖椒250g", "序号": "173", "数量": "9.36", "笔数": "9", "金额": "46.8", "兑换金额": "0", "商品编号": "00066"}, {"单价": "4.0277", "商品": "韭菜150g", "序号": "174", "数量": "11.4706", "笔数": "9", "金额": "46.2", "兑换金额": "0", "商品编号": "00071"}, {"单价": "25.1989", "商品": "香樁150g", "序号": "175", "数量": "1.8096", "笔数": "2", "金额": "45.6", "兑换金额": "0", "商品编号": "00155"}, {"单价": "9", "商品": "雲吞麵（幼）350g", "序号": "176", "数量": "5", "笔数": "5", "金额": "45", "兑换金额": "0", "商品编号": "00208"}, {"单价": "15", "商品": "招牌叉燒包 120g*4個", "序号": "177", "数量": "3", "笔数": "3", "金额": "45", "兑换金额": "0", "商品编号": "00537"}, {"单价": "6.8", "商品": "竹蔗", "序号": "178", "数量": "6.5441", "笔数": "4", "金额": "44.5", "兑换金额": "0", "商品编号": "00058"}, {"单价": "8.9", "商品": "蒜心300g", "序号": "179", "数量": "5", "笔数": "5", "金额": "44.5", "兑换金额": "0", "商品编号": "00072"}, {"单价": "8.6", "商品": "香素雞200g/袋", "序号": "180", "数量": "5", "笔数": "4", "金额": "43", "兑换金额": "0", "商品编号": "00343"}, {"单价": "5.7", "商品": "蒲瓜", "序号": "181", "数量": "7.421", "笔数": "6", "金额": "42.3", "兑换金额": "0", "商品编号": "00027"}, {"单价": "5.3999", "商品": "青蘿蔔", "序号": "182", "数量": "7.6483", "笔数": "10", "金额": "41.3", "兑换金额": "0", "商品编号": "00043"}, {"单价": "8.3999", "商品": "水果蘿蔔", "序号": "183", "数量": "4.8929", "笔数": "8", "金额": "41.1", "兑换金额": "0", "商品编号": "00044"}, {"单价": "5.2999", "商品": "青木瓜", "序号": "184", "数量": "7.7548", "笔数": "6", "金额": "41.1", "兑换金额": "0", "商品编号": "00113"}, {"单价": "5.5811", "商品": "黃皮椒250g", "序号": "185", "数量": "7.2746", "笔数": "4", "金额": "40.6", "兑换金额": "0", "商品编号": "00063"}, {"单价": "7.7", "商品": "沙葛", "序号": "186", "数量": "5.1948", "笔数": "6", "金额": "40", "兑换金额": "0", "商品编号": "00057"}, {"单价": "10", "商品": "果凍橙", "序号": "187", "数量": "4", "笔数": "2", "金额": "40", "兑换金额": "0", "商品编号": "00131"}, {"单价": "8", "商品": "油麵350g", "序号": "188", "数量": "5", "笔数": "3", "金额": "40", "兑换金额": "0", "商品编号": "00204"}, {"单价": "7.6", "商品": "茅根150g", "序号": "189", "数量": "5", "笔数": "5", "金额": "38", "兑换金额": "0", "商品编号": "00099"}, {"单价": "9.2002", "商品": "黃金蜜薯500g", "序号": "190", "数量": "3.826", "笔数": "2", "金额": "35.2", "兑换金额": "0", "商品编号": "00132"}, {"单价": "4", "商品": "黃豆芽300g", "序号": "191", "数量": "8.75", "笔数": "9", "金额": "35", "兑换金额": "0", "商品编号": "00056"}, {"单价": "48.001100000000001", "商品": "瘦肉", "序号": "192", "数量": "0.7104", "笔数": "1", "金额": "34.1", "兑换金额": "0", "商品编号": "00276"}, {"单价": "77.99120000000001", "商品": "骨腩", "序号": "193", "数量": "0.4321", "笔数": "1", "金额": "33.7", "兑换金额": "0", "商品编号": "00285"}, {"单价": "6.7", "商品": "客家豆腐380g/盒", "序号": "194", "数量": "5", "笔数": "5", "金额": "33.5", "兑换金额": "0", "商品编号": "00340"}, {"单价": "5", "商品": "肥肉", "序号": "195", "数量": "6.64", "笔数": "2", "金额": "33.2", "兑换金额": "0", "商品编号": "00258"}, {"单价": "7.5998", "商品": "水東芥菜450g", "序号": "196", "数量": "4.3422", "笔数": "6", "金额": "33", "兑换金额": "0", "商品编号": "00013"}, {"单价": "8", "商品": "豬腰（個）", "序号": "197", "数量": "4", "笔数": "1", "金额": "32", "兑换金额": "0", "商品编号": "00256"}, {"单价": "88", "商品": "排骨粒", "序号": "198", "数量": "0.3625", "笔数": "1", "金额": "31.9", "兑换金额": "0", "商品编号": "00272"}, {"单价": "3.7002", "商品": "枸杞葉180g", "序号": "199", "数量": "8.5131", "笔数": "9", "金额": "31.5", "兑换金额": "0", "商品编号": "00082"}, {"单价": "88.011300000000006", "商品": "有筋腱", "序号": "200", "数量": "0.3545", "笔数": "1", "金额": "31.2", "兑换金额": "0", "商品编号": "00274"}, {"单价": "4.8", "商品": "大平包", "序号": "201", "数量": "6.25", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00010"}, {"单价": "5.9601", "商品": "蟹味菇150g", "序号": "202", "数量": "5.0335", "笔数": "5", "金额": "30", "兑换金额": "0", "商品编号": "00103"}, {"单价": "11.3999", "商品": "西椒550g", "序号": "203", "数量": "2.6316", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00110"}, {"单价": "15", "商品": "奶白饅頭45g*12個", "序号": "204", "数量": "2", "笔数": "2", "金额": "30", "兑换金额": "0", "商品编号": "00145"}, {"单价": "6.2001", "商品": "海帶結200g", "序号": "205", "数量": "4.758", "笔数": "4", "金额": "29.5", "兑换金额": "0", "商品编号": "00364"}, {"单价": "9.6598", "商品": "芒果", "序号": "206", "数量": "3.0125", "笔数": "2", "金额": "29.1", "兑换金额": "0", "商品编号": "00406"}, {"单价": "37.9981", "商品": "豬粉腸", "序号": "207", "数量": "0.7553", "笔数": "2", "金额": "28.7", "兑换金额": "0", "商品编号": "00248"}, {"单价": "67.99209999999999", "商品": "梅頭豬扒", "序号": "208", "数量": "0.4074", "笔数": "1", "金额": "27.7", "兑换金额": "0", "商品编号": "00270"}, {"单价": "6.1003", "商品": "盒裝豆苗200g", "序号": "209", "数量": "4.508", "笔数": "2", "金额": "27.5", "兑换金额": "0", "商品编号": "00054"}, {"单价": "9", "商品": "皮蛋4只", "序号": "210", "数量": "3", "笔数": "3", "金额": "27", "兑换金额": "0", "商品编号": "00146"}, {"单价": "5.3", "商品": "蒜苗150g", "序号": "211", "数量": "5", "笔数": "3", "金额": "26.5", "兑换金额": "0", "商品编号": "00120"}, {"单价": "6.4358", "商品": "白玉菇150g", "序号": "212", "数量": "4.0399", "笔数": "5", "金额": "26", "兑换金额": "0", "商品编号": "00104"}, {"单价": "8.5", "商品": "上海雲吞皮（白方皮）350g", "序号": "213", "数量": "3", "笔数": "3", "金额": "25.5", "兑换金额": "0", "商品编号": "00207"}, {"单价": "5", "商品": "紫蘇150g", "序号": "214", "数量": "5", "笔数": "4", "金额": "25", "兑换金额": "0", "商品编号": "00121"}, {"单价": "1", "商品": "膠袋", "序号": "215", "数量": "25", "笔数": "24", "金额": "25", "兑换金额": "0", "商品编号": "00300"}, {"单价": "12.5", "商品": "盒裝枇杷", "序号": "216", "数量": "2", "笔数": "1", "金额": "25", "兑换金额": "0", "商品编号": "00543"}, {"单价": "5.7", "商品": "銀絲王300g", "序号": "217", "数量": "4.2105", "笔数": "5", "金额": "24", "兑换金额": "0", "商品编号": "00005"}, {"单价": "14.069599999999999", "商品": "豬耳2只", "序号": "218", "数量": "1.7058", "笔数": "2", "金额": "24", "兑换金额": "0", "商品编号": "00261"}, {"单价": "10.4998", "商品": "西蘭花苗200g", "序号": "219", "数量": "2.1429", "笔数": "2", "金额": "22.5", "兑换金额": "0", "商品编号": "00370"}, {"单价": "5.5", "商品": "綠九芽生菜300g", "序号": "220", "数量": "4", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00078"}, {"单价": "4.8001", "商品": "鮮蘑菇(海鮮菇)250g", "序号": "221", "数量": "4.5832", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00106"}, {"单价": "7", "商品": "雪蓮果", "序号": "222", "数量": "3", "笔数": "2", "金额": "21", "兑换金额": "0", "商品编号": "00330"}, {"单价": "10", "商品": "豬心（個）", "序号": "223", "数量": "2", "笔数": "1", "金额": "20", "兑换金额": "0", "商品编号": "00249"}, {"单价": "10", "商品": "青梅", "序号": "224", "数量": "2", "笔数": "2", "金额": "20", "兑换金额": "0", "商品编号": "00674"}, {"单价": "9.5", "商品": "蝦米腸粉", "序号": "225", "数量": "2", "笔数": "2", "金额": "19", "兑换金额": "0", "商品编号": "00202"}, {"单价": "18", "商品": "豬利（條）", "序号": "226", "数量": "1", "笔数": "1", "金额": "18", "兑换金额": "0", "商品编号": "00250"}, {"单价": "8", "商品": "拉麵350g", "序号": "227", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00151"}, {"单价": "8", "商品": "白腸粉", "序号": "228", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00203"}, {"单价": "15.5", "商品": "蔥香手抓餅97g*4片", "序号": "229", "数量": "1", "笔数": "1", "金额": "15.5", "兑换金额": "0", "商品编号": "00417"}, {"单价": "15", "商品": "馬鮫魚丸250g/包", "序号": "230", "数量": "1", "笔数": "1", "金额": "15", "兑换金额": "0", "商品编号": "00354"}, {"单价": "10", "商品": "隔山", "序号": "231", "数量": "1.48", "笔数": "1", "金额": "14.8", "兑换金额": "0", "商品编号": "00240"}, {"单价": "12.00050000000000061", "商品": "大青芒", "序号": "232", "数量": "0.8333", "笔数": "1", "金额": "10", "兑换金额": "0", "商品编号": "00493"}, {"单价": "5.2997", "商品": "魚腥草150g", "序号": "233", "数量": "1.6982", "笔数": "2", "金额": "9", "兑换金额": "0", "商品编号": "00059"}, {"单价": "8.4005", "商品": "板栗番薯", "序号": "234", "数量": "0.869", "笔数": "1", "金额": "7.3", "兑换金额": "0", "商品编号": "00042"}, {"单价": "11", "商品": "儿菜", "序号": "235", "数量": "0.6", "笔数": "1", "金额": "6.6", "兑换金额": "0", "商品编号": "00655"}, {"单价": "4.4", "商品": "沙薑100g", "序号": "236", "数量": "0.9091", "笔数": "1", "金额": "4", "兑换金额": "0", "商品编号": "00115"}, {"单价": "5.7001", "商品": "紅蔥頭（吊幹蔥)100g", "序号": "237", "数量": "0.6842", "笔数": "1", "金额": "3.9", "兑换金额": "0", "商品编号": "00114"}]	{"items": [], "summary": "AI分析失败"}	2026-03-31 22:04:35	2026-03-31 22:04:36
2	1	8	零售报表分析-零售-零售汇总_1774399133339.xlsx	sales_uploads/1/20260331_221556_零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-03-31	3	237	0	0	AI未能识别有效销售数据：AI分析失败	[{"单价": "97.9948", "商品": "豬肉100元", "序号": "1", "数量": "77.3", "笔数": "87", "金额": "7575", "兑换金额": "0", "商品编号": "10000"}, {"单价": "6.8939", "商品": "耙耙柑", "序号": "2", "数量": "103.5702", "笔数": "29", "金额": "714", "兑换金额": "0", "商品编号": "00195"}, {"单价": "62.0018000000000029", "商品": "清遠雞1.1-1.3KG", "序号": "3", "数量": "10.8384", "笔数": "7", "金额": "672", "兑换金额": "0", "商品编号": "00173"}, {"单价": "7.9401", "商品": "地們香蕉", "序号": "4", "数量": "80.629", "笔数": "50", "金额": "640.20000000000005", "兑换金额": "0", "商品编号": "00129"}, {"单价": "51.4075", "商品": "黃花魚", "序号": "5", "数量": "10.8525", "笔数": "18", "金额": "557.89999999999998", "兑换金额": "0", "商品编号": "00223"}, {"单价": "3.5", "商品": "紅蔥(香蔥)100g", "序号": "6", "数量": "135", "笔数": "104", "金额": "472.5", "兑换金额": "0", "商品编号": "00306"}, {"单价": "12.2869", "商品": "西蘭花", "序号": "7", "数量": "37.9673", "笔数": "80", "金额": "466.5", "兑换金额": "0", "商品编号": "00012"}, {"单价": "41.9999", "商品": "王立鯧", "序号": "8", "数量": "10.5167", "笔数": "16", "金额": "441.69999999999999", "兑换金额": "0", "商品编号": "00224"}, {"单价": "20", "商品": "散裝串茄", "序号": "9", "数量": "21.545", "笔数": "15", "金额": "430.89999999999998", "兑换金额": "0", "商品编号": "00654"}, {"单价": "10.4003", "商品": "榴槤番薯500g", "序号": "10", "数量": "39.027900000000002", "笔数": "35", "金额": "405.89999999999998", "兑换金额": "0", "商品编号": "00391"}, {"单价": "20", "商品": "白蝦肉200g", "序号": "11", "数量": "20", "笔数": "17", "金额": "400", "兑换金额": "0", "商品编号": "00154"}, {"单价": "9", "商品": "蒜頭220g", "序号": "12", "数量": "44", "笔数": "38", "金额": "396", "兑换金额": "0", "商品编号": "00117"}, {"单价": "5.1", "商品": "胡蘿蔔(紅蘿蔔)", "序号": "13", "数量": "77.56870000000001", "笔数": "78", "金额": "395.60000000000002", "兑换金额": "0", "商品编号": "00047"}, {"单价": "71.9984", "商品": "一字排", "序号": "14", "数量": "5.4154", "笔数": "6", "金额": "389.89999999999998", "兑换金额": "0", "商品编号": "00282"}, {"单价": "13.9392", "商品": "小藍莓", "序号": "15", "数量": "27.6916", "笔数": "15", "金额": "386", "兑换金额": "0", "商品编号": "00467"}, {"单价": "52", "商品": "龍崗雞", "序号": "16", "数量": "7", "笔数": "6", "金额": "364", "兑换金额": "0", "商品编号": "00649"}, {"单价": "31.028400000000001", "商品": "士多啤梨", "序号": "17", "数量": "11.28", "笔数": "10", "金额": "350", "兑换金额": "0", "商品编号": "00404"}, {"单价": "6.3554", "商品": "芭樂", "序号": "18", "数量": "54.2846", "笔数": "19", "金额": "345", "兑换金额": "0", "商品编号": "00410"}, {"单价": "10.4", "商品": "薑(生薑)300g", "序号": "19", "数量": "33", "笔数": "33", "金额": "343.19999999999999", "兑换金额": "0", "商品编号": "00116"}, {"单价": "18", "商品": "鮮雞蛋", "序号": "20", "数量": "18", "笔数": "16", "金额": "324", "兑换金额": "0", "商品编号": "00566"}, {"单价": "13.4866", "商品": "苦瓜", "序号": "21", "数量": "23.6087", "笔数": "55", "金额": "318.39999999999998", "兑换金额": "0", "商品编号": "00025"}, {"单价": "5.8001", "商品": "唐生菜300g", "序号": "22", "数量": "54.4644", "笔数": "66", "金额": "315.89999999999998", "兑换金额": "0", "商品编号": "00079"}, {"单价": "48.0015000000000001", "商品": "三黃雞", "序号": "23", "数量": "6.4998", "笔数": "6", "金额": "312", "兑换金额": "0", "商品编号": "00648"}, {"单价": "5.9219", "商品": "散裝金桔", "序号": "24", "数量": "51.2846", "笔数": "31", "金额": "303.69999999999999", "兑换金额": "0", "商品编号": "00652"}, {"单价": "40", "商品": "鯇魚", "序号": "25", "数量": "7.185", "笔数": "8", "金额": "287.39999999999998", "兑换金额": "0", "商品编号": "00210"}, {"单价": "58.0013000000000005", "商品": "免治豬肉", "序号": "26", "数量": "4.9292", "笔数": "9", "金额": "285.89999999999998", "兑换金额": "0", "商品编号": "00281"}, {"单价": "9.0381", "商品": "青瓜", "序号": "27", "数量": "31.4448", "笔数": "34", "金额": "284.19999999999999", "兑换金额": "0", "商品编号": "00084"}, {"单价": "9.2002", "商品": "白蘑菇200g", "序号": "28", "数量": "30.608", "笔数": "25", "金额": "281.60000000000002", "兑换金额": "0", "商品编号": "00061"}, {"单价": "7.422", "商品": "上海青苗300g", "序号": "29", "数量": "37.6985", "笔数": "37", "金额": "279.80000000000001", "兑换金额": "0", "商品编号": "00019"}, {"单价": "10.4003", "商品": "沙律菜-帶醬150g", "序号": "30", "数量": "25.7013", "笔数": "24", "金额": "267.30000000000001", "兑换金额": "0", "商品编号": "00075"}, {"单价": "8.2628", "商品": "芥蘭苗300g", "序号": "31", "数量": "31.551", "笔数": "28", "金额": "260.69999999999999", "兑换金额": "0", "商品编号": "00014"}, {"单价": "9.0267", "商品": "唐生菜苗250g", "序号": "32", "数量": "28.083500000000001", "笔数": "36", "金额": "253.5", "兑换金额": "0", "商品编号": "00303"}, {"单价": "8.317", "商品": "茄子(紫)", "序号": "33", "数量": "30.4197", "笔数": "48", "金额": "253", "兑换金额": "0", "商品编号": "00029"}, {"单价": "5.9999", "商品": "蜜蜂橙", "序号": "34", "数量": "41.6675", "笔数": "21", "金额": "250", "兑换金额": "0", "商品编号": "00399"}, {"单价": "5.8676", "商品": "馬鈴薯", "序号": "35", "数量": "42.2657", "笔数": "37", "金额": "248", "兑换金额": "0", "商品编号": "00051"}, {"单价": "12.6", "商品": "芋頭", "序号": "36", "数量": "18.9127", "笔数": "20", "金额": "238.30000000000001", "兑换金额": "0", "商品编号": "00052"}, {"单价": "5", "商品": "白洋蔥", "序号": "37", "数量": "47.28", "笔数": "49", "金额": "236.40000000000001", "兑换金额": "0", "商品编号": "00073"}, {"单价": "6.5771", "商品": "青通300g", "序号": "38", "数量": "34.5896", "笔数": "31", "金额": "227.5", "兑换金额": "0", "商品编号": "00017"}, {"单价": "6.5", "商品": "番茄(粉)350g", "序号": "39", "数量": "35", "笔数": "30", "金额": "227.5", "兑换金额": "0", "商品编号": "00030"}, {"单价": "3.5", "商品": "芫茜70g", "序号": "40", "数量": "65", "笔数": "53", "金额": "227.5", "兑换金额": "0", "商品编号": "00307"}, {"单价": "10.4998", "商品": "菠菜苗300g", "序号": "41", "数量": "21.429", "笔数": "28", "金额": "225", "兑换金额": "0", "商品编号": "00006"}, {"单价": "13.00050000000000061", "商品": "水果椒250g", "序号": "42", "数量": "17.307", "笔数": "18", "金额": "225", "兑换金额": "0", "商品编号": "00107"}, {"单价": "13.6765", "商品": "菠蘿蜜", "序号": "43", "数量": "16.085999999999999", "笔数": "14", "金额": "220", "兑换金额": "0", "商品编号": "00462"}, {"单价": "8.8441", "商品": "水果油瓜400g", "序号": "44", "数量": "24.717", "笔数": "26", "金额": "218.59999999999999", "兑换金额": "0", "商品编号": "00266"}, {"单价": "2.5", "商品": "檸檬", "序号": "45", "数量": "86.40000000000001", "笔数": "16", "金额": "216", "兑换金额": "0", "商品编号": "00446"}, {"单价": "8.2004", "商品": "白豆角300g", "序号": "46", "数量": "25.6084", "笔数": "28", "金额": "210", "兑换金额": "0", "商品编号": "00036"}, {"单价": "7.5899", "商品": "木瓜", "序号": "47", "数量": "27.6684", "笔数": "17", "金额": "210", "兑换金额": "0", "商品编号": "00193"}, {"单价": "4.2", "商品": "京包", "序号": "48", "数量": "49.4286", "笔数": "30", "金额": "207.59999999999999", "兑换金额": "0", "商品编号": "00007"}, {"单价": "8.6", "商品": "板栗南瓜", "序号": "49", "数量": "24.0581", "笔数": "14", "金额": "206.90000000000001", "兑换金额": "0", "商品编号": "00086"}, {"单价": "67.99930000000001", "商品": "霖肉", "序号": "50", "数量": "3.0015000000000001", "笔数": "5", "金额": "204.099999999999994", "兑换金额": "0", "商品编号": "00280"}, {"单价": "25", "商品": "日本白蛋10只", "序号": "51", "数量": "8", "笔数": "8", "金额": "200", "兑换金额": "0", "商品编号": "00217"}, {"单价": "6.1", "商品": "聖女果300g", "序号": "52", "数量": "32.4588", "笔数": "31", "金额": "198", "兑换金额": "0", "商品编号": "00392"}, {"单价": "9", "商品": "大牛油果", "序号": "53", "数量": "21.4445", "笔数": "6", "金额": "193", "兑换金额": "0", "商品编号": "00486"}, {"单价": "6.6003", "商品": "番茄350g", "序号": "54", "数量": "29.1655", "笔数": "31", "金额": "192.5", "兑换金额": "0", "商品编号": "00089"}, {"单价": "9.1429", "商品": "鹽水花生", "序号": "55", "数量": "21", "笔数": "17", "金额": "192", "兑换金额": "0", "商品编号": "00470"}, {"单价": "7.6729", "商品": "菜心苗300g", "序号": "56", "数量": "24.7625", "笔数": "17", "金额": "190", "兑换金额": "0", "商品编号": "00022"}, {"单价": "41.9998", "商品": "沙鑽魚", "序号": "57", "数量": "4.4905", "笔数": "8", "金额": "188.59999999999999", "兑换金额": "0", "商品编号": "00668"}, {"单价": "17.2993", "商品": "串茄198g", "序号": "58", "数量": "10.8097", "笔数": "10", "金额": "187", "兑换金额": "0", "商品编号": "00309"}, {"单价": "9", "商品": "牛奶蕉", "序号": "59", "数量": "20.3445", "笔数": "13", "金额": "183.099999999999994", "兑换金额": "0", "商品编号": "00468"}, {"单价": "34.9994", "商品": "豬潤", "序号": "60", "数量": "5.1258", "笔数": "10", "金额": "179.40000000000001", "兑换金额": "0", "商品编号": "00268"}, {"单价": "72.00060000000000571", "商品": "文昌雞1.1-1.3KG", "序号": "61", "数量": "2.4722", "笔数": "2", "金额": "178", "兑换金额": "0", "商品编号": "00319"}, {"单价": "7.5", "商品": "辣椒(杭椒)250g", "序号": "62", "数量": "23", "笔数": "16", "金额": "172.5", "兑换金额": "0", "商品编号": "00111"}, {"单价": "6.9526", "商品": "上海青300g", "序号": "63", "数量": "24.6814", "笔数": "33", "金额": "171.59999999999999", "兑换金额": "0", "商品编号": "00018"}, {"单价": "40", "商品": "大頭魚", "序号": "64", "数量": "4.27", "笔数": "5", "金额": "170.80000000000001", "兑换金额": "0", "商品编号": "00289"}, {"单价": "8.8999", "商品": "玉米(甜)", "序号": "65", "数量": "18.899", "笔数": "26", "金额": "168.19999999999999", "兑换金额": "0", "商品编号": "00033"}, {"单价": "4.1001", "商品": "小土豆400g", "序号": "66", "数量": "40.9016", "笔数": "31", "金额": "167.69999999999999", "兑换金额": "0", "商品编号": "00096"}, {"单价": "16.5998", "商品": "三色彩椒550g", "序号": "67", "数量": "9.8736", "笔数": "11", "金额": "163.90000000000001", "兑换金额": "0", "商品编号": "00112"}, {"单价": "23.2558", "商品": "蘆筍200g", "序号": "68", "数量": "6.88", "笔数": "10", "金额": "160", "兑换金额": "0", "商品编号": "00050"}, {"单价": "7.3968", "商品": "黄秋葵200g", "序号": "69", "数量": "20.8198", "笔数": "20", "金额": "154", "兑换金额": "0", "商品编号": "00088"}, {"单价": "7", "商品": "百福蒸煮豆腐350ml/盒", "序号": "70", "数量": "22", "笔数": "19", "金额": "154", "兑换金额": "0", "商品编号": "00189"}, {"单价": "9.4999", "商品": "油麥菜苗250g", "序号": "71", "数量": "15.9159", "笔数": "20", "金额": "151.19999999999999", "兑换金额": "0", "商品编号": "00304"}, {"单价": "5.9", "商品": "地瓜葉300g", "序号": "72", "数量": "25.1694", "笔数": "24", "金额": "148.5", "兑换金额": "0", "商品编号": "00077"}, {"单价": "52.014699999999998", "商品": "肉眼（肉扒）", "序号": "73", "数量": "2.8242", "笔数": "4", "金额": "146.90000000000001", "兑换金额": "0", "商品编号": "00273"}, {"单价": "9.5004", "商品": "大紅椒250g", "序号": "74", "数量": "15.2099", "笔数": "4", "金额": "144.5", "兑换金额": "0", "商品编号": "00109"}, {"单价": "12.6004", "商品": "甜豆300g", "序号": "75", "数量": "11.4282", "笔数": "17", "金额": "144", "兑换金额": "0", "商品编号": "00039"}, {"单价": "37.9987", "商品": "竹絲雞（小 ）0.9-1.0KG", "序号": "76", "数量": "3.7896", "笔数": "4", "金额": "144", "兑换金额": "0", "商品编号": "00316"}, {"单价": "12", "商品": "菠蘿", "序号": "77", "数量": "12", "笔数": "12", "金额": "144", "兑换金额": "0", "商品编号": "00439"}, {"单价": "4.1002", "商品": "珠蔥150g", "序号": "78", "数量": "34.2914", "笔数": "31", "金额": "140.59999999999999", "兑换金额": "0", "商品编号": "00067"}, {"单价": "8.2997", "商品": "娃娃菜（三個装）", "序号": "79", "数量": "16.868", "笔数": "20", "金额": "140", "兑换金额": "0", "商品编号": "00001"}, {"单价": "4.4", "商品": "冬瓜", "序号": "80", "数量": "31.7046", "笔数": "22", "金额": "139.5", "兑换金额": "0", "商品编号": "00023"}, {"单价": "29.9996", "商品": "星鱸", "序号": "81", "数量": "4.6434", "笔数": "5", "金额": "139.30000000000001", "兑换金额": "0", "商品编号": "00226"}, {"单价": "5.7999", "商品": "湖南椒250g", "序号": "82", "数量": "23.7075", "笔数": "16", "金额": "137.5", "兑换金额": "0", "商品编号": "00065"}, {"单价": "8.5", "商品": "豆蔔1份", "序号": "83", "数量": "16", "笔数": "15", "金额": "136", "兑换金额": "0", "商品编号": "00194"}, {"单价": "6.8", "商品": "攸縣香干200g/袋", "序号": "84", "数量": "20", "笔数": "20", "金额": "136", "兑换金额": "0", "商品编号": "00342"}, {"单价": "20.3191", "商品": "枇杷", "序号": "85", "数量": "6.644", "笔数": "6", "金额": "135", "兑换金额": "0", "商品编号": "00395"}, {"单价": "8.9002", "商品": "荷蘭豆200g", "序号": "86", "数量": "14.9435", "笔数": "16", "金额": "133", "兑换金额": "0", "商品编号": "00037"}, {"单价": "13.9374", "商品": "鮮淮山", "序号": "87", "数量": "9.5355", "笔数": "9", "金额": "132.90000000000001", "兑换金额": "0", "商品编号": "00095"}, {"单价": "8.1843", "商品": "菜心300g", "序号": "88", "数量": "15.8841", "笔数": "15", "金额": "130", "兑换金额": "0", "商品编号": "00021"}, {"单价": "12.2002", "商品": "板栗肉200g", "序号": "89", "数量": "10.6392", "笔数": "11", "金额": "129.80000000000001", "兑换金额": "0", "商品编号": "00038"}, {"单价": "10.887", "商品": "福建花(散花）", "序号": "90", "数量": "11.7204", "笔数": "14", "金额": "127.59999999999999", "兑换金额": "0", "商品编号": "00386"}, {"单价": "25", "商品": "羅非魚", "序号": "91", "数量": "5.084", "笔数": "6", "金额": "127.099999999999994", "兑换金额": "0", "商品编号": "00292"}, {"单价": "7.0001", "商品": "指天椒100g", "序号": "92", "数量": "18.071100000000001", "笔数": "22", "金额": "126.5", "兑换金额": "0", "商品编号": "00108"}, {"单价": "3.4001", "商品": "金針菇200g", "序号": "93", "数量": "36.8808", "笔数": "24", "金额": "125.40000000000001", "兑换金额": "0", "商品编号": "00100"}, {"单价": "7.8", "商品": "南瓜(貝貝南瓜)", "序号": "94", "数量": "15.8206", "笔数": "16", "金额": "123.40000000000001", "兑换金额": "0", "商品编号": "00085"}, {"单价": "7.7", "商品": "西芹", "序号": "95", "数量": "15.7012", "笔数": "30", "金额": "120.90000000000001", "兑换金额": "0", "商品编号": "00069"}, {"单价": "103.4808", "商品": "梅頭瘦肉", "序号": "96", "数量": "1.1664", "笔数": "3", "金额": "120.7", "兑换金额": "0", "商品编号": "00283"}, {"单价": "5.1", "商品": "辣椒(螺絲椒)250g", "序号": "97", "数量": "23.5296", "笔数": "15", "金额": "120", "兑换金额": "0", "商品编号": "00064"}, {"单价": "4.0998", "商品": "綠豆芽300g", "序号": "98", "数量": "29.0258", "笔数": "31", "金额": "119", "兑换金额": "0", "商品编号": "00055"}, {"单价": "9.1649", "商品": "學鬥白菜300g", "序号": "99", "数量": "12.9298", "笔数": "14", "金额": "118.5", "兑换金额": "0", "商品编号": "00390"}, {"单价": "49.1776", "商品": "白倉魚", "序号": "100", "数量": "2.4015", "笔数": "4", "金额": "118.099999999999994", "兑换金额": "0", "商品编号": "00667"}, {"单价": "4.3607", "商品": "白蘿蔔", "序号": "101", "数量": "26.4864", "笔数": "23", "金额": "115.5", "兑换金额": "0", "商品编号": "00045"}, {"单价": "9.8995", "商品": "大蔥", "序号": "102", "数量": "11.6066", "笔数": "16", "金额": "114.90000000000001", "兑换金额": "0", "商品编号": "00068"}, {"单价": "8.6348", "商品": "毛瓜", "序号": "103", "数量": "13.0518", "笔数": "16", "金额": "112.7", "兑换金额": "0", "商品编号": "00083"}, {"单价": "11.2999", "商品": "毛豆500g", "序号": "104", "数量": "9.9558", "笔数": "8", "金额": "112.5", "兑换金额": "0", "商品编号": "00092"}, {"单价": "5", "商品": "小旺菜", "序号": "105", "数量": "22.46", "笔数": "17", "金额": "112.3", "兑换金额": "0", "商品编号": "00004"}, {"单价": "3.9205", "商品": "木耳200g", "序号": "106", "数量": "27.8536", "笔数": "3", "金额": "109.2", "兑换金额": "0", "商品编号": "00062"}, {"单价": "10.7001", "商品": "四季豆450g", "序号": "107", "数量": "9.813", "笔数": "10", "金额": "105", "兑换金额": "0", "商品编号": "00034"}, {"单价": "7.8997", "商品": "冬菇200g", "序号": "108", "数量": "13.2916", "笔数": "13", "金额": "105", "兑换金额": "0", "商品编号": "00101"}, {"单价": "10.6003", "商品": "馬蹄500g", "序号": "109", "数量": "9.8582", "笔数": "11", "金额": "104.5", "兑换金额": "0", "商品编号": "00041"}, {"单价": "7.1", "商品": "紅菜頭", "序号": "110", "数量": "14.6901", "笔数": "14", "金额": "104.3", "兑换金额": "0", "商品编号": "00048"}, {"单价": "60.4825", "商品": "五花腩", "序号": "111", "数量": "1.7162", "笔数": "2", "金额": "103.8", "兑换金额": "0", "商品编号": "00284"}, {"单价": "13.6999", "商品": "粉葛", "序号": "112", "数量": "7.5037", "笔数": "6", "金额": "102.8", "兑换金额": "0", "商品编号": "00060"}, {"单价": "10.3352", "商品": "椰菜花(白花菜)", "序号": "113", "数量": "9.9369", "笔数": "10", "金额": "102.7", "兑换金额": "0", "商品编号": "00011"}, {"单价": "5.8", "商品": "胡蘿蔔(泥紅蘿蔔)", "序号": "114", "数量": "17.1379", "笔数": "27", "金额": "99.40000000000001", "兑换金额": "0", "商品编号": "00046"}, {"单价": "8.8999", "商品": "糖心蜜薯", "序号": "115", "数量": "10.9327", "笔数": "10", "金额": "97.3", "兑换金额": "0", "商品编号": "00093"}, {"单价": "97.9996", "商品": "飛排", "序号": "116", "数量": "0.9898", "笔数": "2", "金额": "97", "兑换金额": "0", "商品编号": "00279"}, {"单价": "8", "商品": "百福硬豆腐340g/盒", "序号": "117", "数量": "12", "笔数": "8", "金额": "96", "兑换金额": "0", "商品编号": "00188"}, {"单价": "7.9", "商品": "小咖啡菇200g", "序号": "118", "数量": "12", "笔数": "11", "金额": "94.8", "兑换金额": "0", "商品编号": "00118"}, {"单价": "6.2971", "商品": "油麥菜300g", "序号": "119", "数量": "14.864", "笔数": "18", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00020"}, {"单价": "8.7957", "商品": "秀珍菇150g", "序号": "120", "数量": "10.6416", "笔数": "11", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00322"}, {"单价": "8.2996", "商品": "毛豆仁200g", "序号": "121", "数量": "11.2776", "笔数": "9", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00372"}, {"单价": "8.5", "商品": "上海水餃皮（白圓皮）350g", "序号": "122", "数量": "11", "笔数": "9", "金额": "93.5", "兑换金额": "0", "商品编号": "00206"}, {"单价": "8.5", "商品": "長水瓜", "序号": "123", "数量": "10.8353", "笔数": "13", "金额": "92.099999999999994", "兑换金额": "0", "商品编号": "00031"}, {"单价": "88.0031000000000034", "商品": "豬展", "序号": "124", "数量": "1.0261", "笔数": "3", "金额": "90.3", "兑换金额": "0", "商品编号": "00263"}, {"单价": "7.5679", "商品": "雞毛菜300g", "序号": "125", "数量": "11.8924", "笔数": "7", "金额": "90", "兑换金额": "0", "商品编号": "00327"}, {"单价": "10.5", "商品": "蓮藕", "序号": "126", "数量": "8.4095", "笔数": "9", "金额": "88.3", "兑换金额": "0", "商品编号": "00094"}, {"单价": "13.0063999999999993", "商品": "鮮鐵棍淮山", "序号": "127", "数量": "6.7582", "笔数": "8", "金额": "87.90000000000001", "兑换金额": "0", "商品编号": "00049"}, {"单价": "3.5999", "商品": "芹菜150g", "序号": "128", "数量": "23.334", "笔数": "23", "金额": "84", "兑换金额": "0", "商品编号": "00119"}, {"单价": "42", "商品": "豬肚（個）", "序号": "129", "数量": "2", "笔数": "2", "金额": "84", "兑换金额": "0", "商品编号": "00251"}, {"单价": "12", "商品": "鵪鶉蛋", "序号": "130", "数量": "7", "笔数": "7", "金额": "84", "兑换金额": "0", "商品编号": "00564"}, {"单价": "5.8", "商品": "洋蔥(紅)", "序号": "131", "数量": "14.2759", "笔数": "15", "金额": "82.8", "兑换金额": "0", "商品编号": "00074"}, {"单价": "77.99939999999999", "商品": "排骨頭", "序号": "132", "数量": "1.0577", "笔数": "1", "金额": "82.5", "兑换金额": "0", "商品编号": "00260"}, {"单价": "7.5131", "商品": "萵筍", "序号": "133", "数量": "10.9409", "笔数": "14", "金额": "82.2", "兑换金额": "0", "商品编号": "00325"}, {"单价": "6.0001", "商品": "富士苹果", "序号": "134", "数量": "13.3332", "笔数": "3", "金额": "80", "兑换金额": "0", "商品编号": "00427"}, {"单价": "12.2033", "商品": "金奇異果", "序号": "135", "数量": "6.5556", "笔数": "2", "金额": "80", "兑换金额": "0", "商品编号": "00556"}, {"单价": "6.4869", "商品": "韭王150g", "序号": "136", "数量": "12.0243", "笔数": "11", "金额": "78", "兑换金额": "0", "商品编号": "00070"}, {"单价": "12.6", "商品": "百合四頭", "序号": "137", "数量": "6", "笔数": "6", "金额": "75.59999999999999", "兑换金额": "0", "商品编号": "00362"}, {"单价": "5.4999", "商品": "羽衣甘藍150g", "序号": "138", "数量": "13.6365", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00009"}, {"单价": "9.2891", "商品": "茼蒿300g", "序号": "139", "数量": "8.074", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00401"}, {"单价": "62.003300000000003", "商品": "西施", "序号": "140", "数量": "1.208", "笔数": "2", "金额": "74.90000000000001", "兑换金额": "0", "商品编号": "00287"}, {"单价": "4.7", "商品": "大白菜", "序号": "141", "数量": "15.4682", "笔数": "8", "金额": "72.7", "兑换金额": "0", "商品编号": "00003"}, {"单价": "8", "商品": "佛手瓜", "序号": "142", "数量": "9.0375", "笔数": "12", "金额": "72.3", "兑换金额": "0", "商品编号": "00040"}, {"单价": "4.8", "商品": "杭白菜300g", "序号": "143", "数量": "15", "笔数": "1", "金额": "72", "兑换金额": "0", "商品编号": "00076"}, {"单价": "9", "商品": "鹹蛋4只", "序号": "144", "数量": "8", "笔数": "8", "金额": "72", "兑换金额": "0", "商品编号": "00147"}, {"单价": "8.2996", "商品": "豌豆仁200g", "序号": "145", "数量": "8.4582", "笔数": "9", "金额": "70.2", "兑换金额": "0", "商品编号": "00373"}, {"单价": "9.2998", "商品": "真空淮山肉300g", "序号": "146", "数量": "7.312", "笔数": "7", "金额": "68", "兑换金额": "0", "商品编号": "00312"}, {"单价": "6.7", "商品": "攸縣白干200g/袋", "序号": "147", "数量": "10", "笔数": "8", "金额": "67", "兑换金额": "0", "商品编号": "00341"}, {"单价": "7.6", "商品": "紫椰菜", "序号": "148", "数量": "8.6316", "笔数": "6", "金额": "65.59999999999999", "兑换金额": "0", "商品编号": "00008"}, {"单价": "48.3619", "商品": "豬展骨", "序号": "149", "数量": "1.3461", "笔数": "2", "金额": "65.099999999999994", "兑换金额": "0", "商品编号": "00246"}, {"单价": "11.522", "商品": "皇帝菜苗300g", "序号": "150", "数量": "5.6414", "笔数": "9", "金额": "65", "兑换金额": "0", "商品编号": "00324"}, {"单价": "6.1001", "商品": "芋仔300g", "序号": "151", "数量": "10.6392", "笔数": "8", "金额": "64.90000000000001", "兑换金额": "0", "商品编号": "00097"}, {"单价": "9.2", "商品": "玉米筍200g", "序号": "152", "数量": "7", "笔数": "7", "金额": "64.40000000000001", "兑换金额": "0", "商品编号": "00032"}, {"单价": "8.9004", "商品": "紫薯500g", "序号": "153", "数量": "7.1008", "笔数": "8", "金额": "63.2", "兑换金额": "0", "商品编号": "00387"}, {"单价": "7.9", "商品": "人參白薯", "序号": "154", "数量": "8", "笔数": "6", "金额": "63.2", "兑换金额": "0", "商品编号": "00497"}, {"单价": "61.9996", "商品": "脊骨", "序号": "155", "数量": "0.9742", "笔数": "1", "金额": "60.4", "兑换金额": "0", "商品编号": "00264"}, {"单价": "10.4004", "商品": "鮮蘑菇(咖啡菇)200g", "序号": "156", "数量": "5.769", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00105"}, {"单价": "5.9999", "商品": "沙糖桔", "序号": "157", "数量": "10.00019999999999953", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00369"}, {"单价": "2.5", "商品": "百香果", "序号": "158", "数量": "24", "笔数": "2", "金额": "60", "兑换金额": "0", "商品编号": "00443"}, {"单价": "14.9993", "商品": "油柑", "序号": "159", "数量": "4.00020000000000042", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00494"}, {"单价": "11.9995", "商品": "小青瓜400g", "序号": "160", "数量": "4.7502", "笔数": "6", "金额": "57", "兑换金额": "0", "商品编号": "00024"}, {"单价": "8", "商品": "河粉（炒粉）350g", "序号": "161", "数量": "7", "笔数": "6", "金额": "56", "兑换金额": "0", "商品编号": "00212"}, {"单价": "6.3", "商品": "西葫蘆瓜", "序号": "162", "数量": "8.8413", "笔数": "6", "金额": "55.7", "兑换金额": "0", "商品编号": "00028"}, {"单价": "4.4", "商品": "南瓜", "序号": "163", "数量": "12.3864", "笔数": "12", "金额": "54.5", "兑换金额": "0", "商品编号": "00026"}, {"单价": "5.8", "商品": "杏鮑菇200g", "序号": "164", "数量": "9", "笔数": "9", "金额": "52.2", "兑换金额": "0", "商品编号": "00102"}, {"单价": "9.7998", "商品": "糯粟米", "序号": "165", "数量": "5.296", "笔数": "5", "金额": "51.9", "兑换金额": "0", "商品编号": "00091"}, {"单价": "8.5", "商品": "上海麵350g", "序号": "166", "数量": "6", "笔数": "5", "金额": "51", "兑换金额": "0", "商品编号": "00148"}, {"单价": "27.9996", "商品": "包魚骨", "序号": "167", "数量": "1.8036", "笔数": "2", "金额": "50.5", "兑换金额": "0", "商品编号": "00254"}, {"单价": "8.7997", "商品": "西洋菜300g", "序号": "168", "数量": "5.682", "笔数": "7", "金额": "50", "兑换金额": "0", "商品编号": "00323"}, {"单价": "8.3", "商品": "花生(鮮)300g", "序号": "169", "数量": "6", "笔数": "4", "金额": "49.8", "兑换金额": "0", "商品编号": "00321"}, {"单价": "16.5", "商品": "金裝牛肉丸250g/包", "序号": "170", "数量": "3", "笔数": "3", "金额": "49.5", "兑换金额": "0", "商品编号": "00296"}, {"单价": "9.9", "商品": "一點紅番薯", "序号": "171", "数量": "5", "笔数": "5", "金额": "49.5", "兑换金额": "0", "商品编号": "00656"}, {"单价": "7.6747", "商品": "芥蘭300g", "序号": "172", "数量": "6.2022", "笔数": "6", "金额": "47.6", "兑换金额": "0", "商品编号": "00015"}, {"单价": "5", "商品": "青尖椒250g", "序号": "173", "数量": "9.36", "笔数": "9", "金额": "46.8", "兑换金额": "0", "商品编号": "00066"}, {"单价": "4.0277", "商品": "韭菜150g", "序号": "174", "数量": "11.4706", "笔数": "9", "金额": "46.2", "兑换金额": "0", "商品编号": "00071"}, {"单价": "25.1989", "商品": "香樁150g", "序号": "175", "数量": "1.8096", "笔数": "2", "金额": "45.6", "兑换金额": "0", "商品编号": "00155"}, {"单价": "9", "商品": "雲吞麵（幼）350g", "序号": "176", "数量": "5", "笔数": "5", "金额": "45", "兑换金额": "0", "商品编号": "00208"}, {"单价": "15", "商品": "招牌叉燒包 120g*4個", "序号": "177", "数量": "3", "笔数": "3", "金额": "45", "兑换金额": "0", "商品编号": "00537"}, {"单价": "6.8", "商品": "竹蔗", "序号": "178", "数量": "6.5441", "笔数": "4", "金额": "44.5", "兑换金额": "0", "商品编号": "00058"}, {"单价": "8.9", "商品": "蒜心300g", "序号": "179", "数量": "5", "笔数": "5", "金额": "44.5", "兑换金额": "0", "商品编号": "00072"}, {"单价": "8.6", "商品": "香素雞200g/袋", "序号": "180", "数量": "5", "笔数": "4", "金额": "43", "兑换金额": "0", "商品编号": "00343"}, {"单价": "5.7", "商品": "蒲瓜", "序号": "181", "数量": "7.421", "笔数": "6", "金额": "42.3", "兑换金额": "0", "商品编号": "00027"}, {"单价": "5.3999", "商品": "青蘿蔔", "序号": "182", "数量": "7.6483", "笔数": "10", "金额": "41.3", "兑换金额": "0", "商品编号": "00043"}, {"单价": "8.3999", "商品": "水果蘿蔔", "序号": "183", "数量": "4.8929", "笔数": "8", "金额": "41.1", "兑换金额": "0", "商品编号": "00044"}, {"单价": "5.2999", "商品": "青木瓜", "序号": "184", "数量": "7.7548", "笔数": "6", "金额": "41.1", "兑换金额": "0", "商品编号": "00113"}, {"单价": "5.5811", "商品": "黃皮椒250g", "序号": "185", "数量": "7.2746", "笔数": "4", "金额": "40.6", "兑换金额": "0", "商品编号": "00063"}, {"单价": "7.7", "商品": "沙葛", "序号": "186", "数量": "5.1948", "笔数": "6", "金额": "40", "兑换金额": "0", "商品编号": "00057"}, {"单价": "10", "商品": "果凍橙", "序号": "187", "数量": "4", "笔数": "2", "金额": "40", "兑换金额": "0", "商品编号": "00131"}, {"单价": "8", "商品": "油麵350g", "序号": "188", "数量": "5", "笔数": "3", "金额": "40", "兑换金额": "0", "商品编号": "00204"}, {"单价": "7.6", "商品": "茅根150g", "序号": "189", "数量": "5", "笔数": "5", "金额": "38", "兑换金额": "0", "商品编号": "00099"}, {"单价": "9.2002", "商品": "黃金蜜薯500g", "序号": "190", "数量": "3.826", "笔数": "2", "金额": "35.2", "兑换金额": "0", "商品编号": "00132"}, {"单价": "4", "商品": "黃豆芽300g", "序号": "191", "数量": "8.75", "笔数": "9", "金额": "35", "兑换金额": "0", "商品编号": "00056"}, {"单价": "48.001100000000001", "商品": "瘦肉", "序号": "192", "数量": "0.7104", "笔数": "1", "金额": "34.1", "兑换金额": "0", "商品编号": "00276"}, {"单价": "77.99120000000001", "商品": "骨腩", "序号": "193", "数量": "0.4321", "笔数": "1", "金额": "33.7", "兑换金额": "0", "商品编号": "00285"}, {"单价": "6.7", "商品": "客家豆腐380g/盒", "序号": "194", "数量": "5", "笔数": "5", "金额": "33.5", "兑换金额": "0", "商品编号": "00340"}, {"单价": "5", "商品": "肥肉", "序号": "195", "数量": "6.64", "笔数": "2", "金额": "33.2", "兑换金额": "0", "商品编号": "00258"}, {"单价": "7.5998", "商品": "水東芥菜450g", "序号": "196", "数量": "4.3422", "笔数": "6", "金额": "33", "兑换金额": "0", "商品编号": "00013"}, {"单价": "8", "商品": "豬腰（個）", "序号": "197", "数量": "4", "笔数": "1", "金额": "32", "兑换金额": "0", "商品编号": "00256"}, {"单价": "88", "商品": "排骨粒", "序号": "198", "数量": "0.3625", "笔数": "1", "金额": "31.9", "兑换金额": "0", "商品编号": "00272"}, {"单价": "3.7002", "商品": "枸杞葉180g", "序号": "199", "数量": "8.5131", "笔数": "9", "金额": "31.5", "兑换金额": "0", "商品编号": "00082"}, {"单价": "88.011300000000006", "商品": "有筋腱", "序号": "200", "数量": "0.3545", "笔数": "1", "金额": "31.2", "兑换金额": "0", "商品编号": "00274"}, {"单价": "4.8", "商品": "大平包", "序号": "201", "数量": "6.25", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00010"}, {"单价": "5.9601", "商品": "蟹味菇150g", "序号": "202", "数量": "5.0335", "笔数": "5", "金额": "30", "兑换金额": "0", "商品编号": "00103"}, {"单价": "11.3999", "商品": "西椒550g", "序号": "203", "数量": "2.6316", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00110"}, {"单价": "15", "商品": "奶白饅頭45g*12個", "序号": "204", "数量": "2", "笔数": "2", "金额": "30", "兑换金额": "0", "商品编号": "00145"}, {"单价": "6.2001", "商品": "海帶結200g", "序号": "205", "数量": "4.758", "笔数": "4", "金额": "29.5", "兑换金额": "0", "商品编号": "00364"}, {"单价": "9.6598", "商品": "芒果", "序号": "206", "数量": "3.0125", "笔数": "2", "金额": "29.1", "兑换金额": "0", "商品编号": "00406"}, {"单价": "37.9981", "商品": "豬粉腸", "序号": "207", "数量": "0.7553", "笔数": "2", "金额": "28.7", "兑换金额": "0", "商品编号": "00248"}, {"单价": "67.99209999999999", "商品": "梅頭豬扒", "序号": "208", "数量": "0.4074", "笔数": "1", "金额": "27.7", "兑换金额": "0", "商品编号": "00270"}, {"单价": "6.1003", "商品": "盒裝豆苗200g", "序号": "209", "数量": "4.508", "笔数": "2", "金额": "27.5", "兑换金额": "0", "商品编号": "00054"}, {"单价": "9", "商品": "皮蛋4只", "序号": "210", "数量": "3", "笔数": "3", "金额": "27", "兑换金额": "0", "商品编号": "00146"}, {"单价": "5.3", "商品": "蒜苗150g", "序号": "211", "数量": "5", "笔数": "3", "金额": "26.5", "兑换金额": "0", "商品编号": "00120"}, {"单价": "6.4358", "商品": "白玉菇150g", "序号": "212", "数量": "4.0399", "笔数": "5", "金额": "26", "兑换金额": "0", "商品编号": "00104"}, {"单价": "8.5", "商品": "上海雲吞皮（白方皮）350g", "序号": "213", "数量": "3", "笔数": "3", "金额": "25.5", "兑换金额": "0", "商品编号": "00207"}, {"单价": "5", "商品": "紫蘇150g", "序号": "214", "数量": "5", "笔数": "4", "金额": "25", "兑换金额": "0", "商品编号": "00121"}, {"单价": "1", "商品": "膠袋", "序号": "215", "数量": "25", "笔数": "24", "金额": "25", "兑换金额": "0", "商品编号": "00300"}, {"单价": "12.5", "商品": "盒裝枇杷", "序号": "216", "数量": "2", "笔数": "1", "金额": "25", "兑换金额": "0", "商品编号": "00543"}, {"单价": "5.7", "商品": "銀絲王300g", "序号": "217", "数量": "4.2105", "笔数": "5", "金额": "24", "兑换金额": "0", "商品编号": "00005"}, {"单价": "14.069599999999999", "商品": "豬耳2只", "序号": "218", "数量": "1.7058", "笔数": "2", "金额": "24", "兑换金额": "0", "商品编号": "00261"}, {"单价": "10.4998", "商品": "西蘭花苗200g", "序号": "219", "数量": "2.1429", "笔数": "2", "金额": "22.5", "兑换金额": "0", "商品编号": "00370"}, {"单价": "5.5", "商品": "綠九芽生菜300g", "序号": "220", "数量": "4", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00078"}, {"单价": "4.8001", "商品": "鮮蘑菇(海鮮菇)250g", "序号": "221", "数量": "4.5832", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00106"}, {"单价": "7", "商品": "雪蓮果", "序号": "222", "数量": "3", "笔数": "2", "金额": "21", "兑换金额": "0", "商品编号": "00330"}, {"单价": "10", "商品": "豬心（個）", "序号": "223", "数量": "2", "笔数": "1", "金额": "20", "兑换金额": "0", "商品编号": "00249"}, {"单价": "10", "商品": "青梅", "序号": "224", "数量": "2", "笔数": "2", "金额": "20", "兑换金额": "0", "商品编号": "00674"}, {"单价": "9.5", "商品": "蝦米腸粉", "序号": "225", "数量": "2", "笔数": "2", "金额": "19", "兑换金额": "0", "商品编号": "00202"}, {"单价": "18", "商品": "豬利（條）", "序号": "226", "数量": "1", "笔数": "1", "金额": "18", "兑换金额": "0", "商品编号": "00250"}, {"单价": "8", "商品": "拉麵350g", "序号": "227", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00151"}, {"单价": "8", "商品": "白腸粉", "序号": "228", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00203"}, {"单价": "15.5", "商品": "蔥香手抓餅97g*4片", "序号": "229", "数量": "1", "笔数": "1", "金额": "15.5", "兑换金额": "0", "商品编号": "00417"}, {"单价": "15", "商品": "馬鮫魚丸250g/包", "序号": "230", "数量": "1", "笔数": "1", "金额": "15", "兑换金额": "0", "商品编号": "00354"}, {"单价": "10", "商品": "隔山", "序号": "231", "数量": "1.48", "笔数": "1", "金额": "14.8", "兑换金额": "0", "商品编号": "00240"}, {"单价": "12.00050000000000061", "商品": "大青芒", "序号": "232", "数量": "0.8333", "笔数": "1", "金额": "10", "兑换金额": "0", "商品编号": "00493"}, {"单价": "5.2997", "商品": "魚腥草150g", "序号": "233", "数量": "1.6982", "笔数": "2", "金额": "9", "兑换金额": "0", "商品编号": "00059"}, {"单价": "8.4005", "商品": "板栗番薯", "序号": "234", "数量": "0.869", "笔数": "1", "金额": "7.3", "兑换金额": "0", "商品编号": "00042"}, {"单价": "11", "商品": "儿菜", "序号": "235", "数量": "0.6", "笔数": "1", "金额": "6.6", "兑换金额": "0", "商品编号": "00655"}, {"单价": "4.4", "商品": "沙薑100g", "序号": "236", "数量": "0.9091", "笔数": "1", "金额": "4", "兑换金额": "0", "商品编号": "00115"}, {"单价": "5.7001", "商品": "紅蔥頭（吊幹蔥)100g", "序号": "237", "数量": "0.6842", "笔数": "1", "金额": "3.9", "兑换金额": "0", "商品编号": "00114"}]	{"items": [], "summary": "AI分析失败"}	2026-03-31 22:15:56	2026-03-31 22:15:56
3	4	8	零售报表分析-零售-零售汇总_1774399133339.xlsx	sales_uploads/4/20260331_221618_零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-03-31	3	237	0	0	AI未能识别有效销售数据：AI分析失败	[{"单价": "97.9948", "商品": "豬肉100元", "序号": "1", "数量": "77.3", "笔数": "87", "金额": "7575", "兑换金额": "0", "商品编号": "10000"}, {"单价": "6.8939", "商品": "耙耙柑", "序号": "2", "数量": "103.5702", "笔数": "29", "金额": "714", "兑换金额": "0", "商品编号": "00195"}, {"单价": "62.0018000000000029", "商品": "清遠雞1.1-1.3KG", "序号": "3", "数量": "10.8384", "笔数": "7", "金额": "672", "兑换金额": "0", "商品编号": "00173"}, {"单价": "7.9401", "商品": "地們香蕉", "序号": "4", "数量": "80.629", "笔数": "50", "金额": "640.20000000000005", "兑换金额": "0", "商品编号": "00129"}, {"单价": "51.4075", "商品": "黃花魚", "序号": "5", "数量": "10.8525", "笔数": "18", "金额": "557.89999999999998", "兑换金额": "0", "商品编号": "00223"}, {"单价": "3.5", "商品": "紅蔥(香蔥)100g", "序号": "6", "数量": "135", "笔数": "104", "金额": "472.5", "兑换金额": "0", "商品编号": "00306"}, {"单价": "12.2869", "商品": "西蘭花", "序号": "7", "数量": "37.9673", "笔数": "80", "金额": "466.5", "兑换金额": "0", "商品编号": "00012"}, {"单价": "41.9999", "商品": "王立鯧", "序号": "8", "数量": "10.5167", "笔数": "16", "金额": "441.69999999999999", "兑换金额": "0", "商品编号": "00224"}, {"单价": "20", "商品": "散裝串茄", "序号": "9", "数量": "21.545", "笔数": "15", "金额": "430.89999999999998", "兑换金额": "0", "商品编号": "00654"}, {"单价": "10.4003", "商品": "榴槤番薯500g", "序号": "10", "数量": "39.027900000000002", "笔数": "35", "金额": "405.89999999999998", "兑换金额": "0", "商品编号": "00391"}, {"单价": "20", "商品": "白蝦肉200g", "序号": "11", "数量": "20", "笔数": "17", "金额": "400", "兑换金额": "0", "商品编号": "00154"}, {"单价": "9", "商品": "蒜頭220g", "序号": "12", "数量": "44", "笔数": "38", "金额": "396", "兑换金额": "0", "商品编号": "00117"}, {"单价": "5.1", "商品": "胡蘿蔔(紅蘿蔔)", "序号": "13", "数量": "77.56870000000001", "笔数": "78", "金额": "395.60000000000002", "兑换金额": "0", "商品编号": "00047"}, {"单价": "71.9984", "商品": "一字排", "序号": "14", "数量": "5.4154", "笔数": "6", "金额": "389.89999999999998", "兑换金额": "0", "商品编号": "00282"}, {"单价": "13.9392", "商品": "小藍莓", "序号": "15", "数量": "27.6916", "笔数": "15", "金额": "386", "兑换金额": "0", "商品编号": "00467"}, {"单价": "52", "商品": "龍崗雞", "序号": "16", "数量": "7", "笔数": "6", "金额": "364", "兑换金额": "0", "商品编号": "00649"}, {"单价": "31.028400000000001", "商品": "士多啤梨", "序号": "17", "数量": "11.28", "笔数": "10", "金额": "350", "兑换金额": "0", "商品编号": "00404"}, {"单价": "6.3554", "商品": "芭樂", "序号": "18", "数量": "54.2846", "笔数": "19", "金额": "345", "兑换金额": "0", "商品编号": "00410"}, {"单价": "10.4", "商品": "薑(生薑)300g", "序号": "19", "数量": "33", "笔数": "33", "金额": "343.19999999999999", "兑换金额": "0", "商品编号": "00116"}, {"单价": "18", "商品": "鮮雞蛋", "序号": "20", "数量": "18", "笔数": "16", "金额": "324", "兑换金额": "0", "商品编号": "00566"}, {"单价": "13.4866", "商品": "苦瓜", "序号": "21", "数量": "23.6087", "笔数": "55", "金额": "318.39999999999998", "兑换金额": "0", "商品编号": "00025"}, {"单价": "5.8001", "商品": "唐生菜300g", "序号": "22", "数量": "54.4644", "笔数": "66", "金额": "315.89999999999998", "兑换金额": "0", "商品编号": "00079"}, {"单价": "48.0015000000000001", "商品": "三黃雞", "序号": "23", "数量": "6.4998", "笔数": "6", "金额": "312", "兑换金额": "0", "商品编号": "00648"}, {"单价": "5.9219", "商品": "散裝金桔", "序号": "24", "数量": "51.2846", "笔数": "31", "金额": "303.69999999999999", "兑换金额": "0", "商品编号": "00652"}, {"单价": "40", "商品": "鯇魚", "序号": "25", "数量": "7.185", "笔数": "8", "金额": "287.39999999999998", "兑换金额": "0", "商品编号": "00210"}, {"单价": "58.0013000000000005", "商品": "免治豬肉", "序号": "26", "数量": "4.9292", "笔数": "9", "金额": "285.89999999999998", "兑换金额": "0", "商品编号": "00281"}, {"单价": "9.0381", "商品": "青瓜", "序号": "27", "数量": "31.4448", "笔数": "34", "金额": "284.19999999999999", "兑换金额": "0", "商品编号": "00084"}, {"单价": "9.2002", "商品": "白蘑菇200g", "序号": "28", "数量": "30.608", "笔数": "25", "金额": "281.60000000000002", "兑换金额": "0", "商品编号": "00061"}, {"单价": "7.422", "商品": "上海青苗300g", "序号": "29", "数量": "37.6985", "笔数": "37", "金额": "279.80000000000001", "兑换金额": "0", "商品编号": "00019"}, {"单价": "10.4003", "商品": "沙律菜-帶醬150g", "序号": "30", "数量": "25.7013", "笔数": "24", "金额": "267.30000000000001", "兑换金额": "0", "商品编号": "00075"}, {"单价": "8.2628", "商品": "芥蘭苗300g", "序号": "31", "数量": "31.551", "笔数": "28", "金额": "260.69999999999999", "兑换金额": "0", "商品编号": "00014"}, {"单价": "9.0267", "商品": "唐生菜苗250g", "序号": "32", "数量": "28.083500000000001", "笔数": "36", "金额": "253.5", "兑换金额": "0", "商品编号": "00303"}, {"单价": "8.317", "商品": "茄子(紫)", "序号": "33", "数量": "30.4197", "笔数": "48", "金额": "253", "兑换金额": "0", "商品编号": "00029"}, {"单价": "5.9999", "商品": "蜜蜂橙", "序号": "34", "数量": "41.6675", "笔数": "21", "金额": "250", "兑换金额": "0", "商品编号": "00399"}, {"单价": "5.8676", "商品": "馬鈴薯", "序号": "35", "数量": "42.2657", "笔数": "37", "金额": "248", "兑换金额": "0", "商品编号": "00051"}, {"单价": "12.6", "商品": "芋頭", "序号": "36", "数量": "18.9127", "笔数": "20", "金额": "238.30000000000001", "兑换金额": "0", "商品编号": "00052"}, {"单价": "5", "商品": "白洋蔥", "序号": "37", "数量": "47.28", "笔数": "49", "金额": "236.40000000000001", "兑换金额": "0", "商品编号": "00073"}, {"单价": "6.5771", "商品": "青通300g", "序号": "38", "数量": "34.5896", "笔数": "31", "金额": "227.5", "兑换金额": "0", "商品编号": "00017"}, {"单价": "6.5", "商品": "番茄(粉)350g", "序号": "39", "数量": "35", "笔数": "30", "金额": "227.5", "兑换金额": "0", "商品编号": "00030"}, {"单价": "3.5", "商品": "芫茜70g", "序号": "40", "数量": "65", "笔数": "53", "金额": "227.5", "兑换金额": "0", "商品编号": "00307"}, {"单价": "10.4998", "商品": "菠菜苗300g", "序号": "41", "数量": "21.429", "笔数": "28", "金额": "225", "兑换金额": "0", "商品编号": "00006"}, {"单价": "13.00050000000000061", "商品": "水果椒250g", "序号": "42", "数量": "17.307", "笔数": "18", "金额": "225", "兑换金额": "0", "商品编号": "00107"}, {"单价": "13.6765", "商品": "菠蘿蜜", "序号": "43", "数量": "16.085999999999999", "笔数": "14", "金额": "220", "兑换金额": "0", "商品编号": "00462"}, {"单价": "8.8441", "商品": "水果油瓜400g", "序号": "44", "数量": "24.717", "笔数": "26", "金额": "218.59999999999999", "兑换金额": "0", "商品编号": "00266"}, {"单价": "2.5", "商品": "檸檬", "序号": "45", "数量": "86.40000000000001", "笔数": "16", "金额": "216", "兑换金额": "0", "商品编号": "00446"}, {"单价": "8.2004", "商品": "白豆角300g", "序号": "46", "数量": "25.6084", "笔数": "28", "金额": "210", "兑换金额": "0", "商品编号": "00036"}, {"单价": "7.5899", "商品": "木瓜", "序号": "47", "数量": "27.6684", "笔数": "17", "金额": "210", "兑换金额": "0", "商品编号": "00193"}, {"单价": "4.2", "商品": "京包", "序号": "48", "数量": "49.4286", "笔数": "30", "金额": "207.59999999999999", "兑换金额": "0", "商品编号": "00007"}, {"单价": "8.6", "商品": "板栗南瓜", "序号": "49", "数量": "24.0581", "笔数": "14", "金额": "206.90000000000001", "兑换金额": "0", "商品编号": "00086"}, {"单价": "67.99930000000001", "商品": "霖肉", "序号": "50", "数量": "3.0015000000000001", "笔数": "5", "金额": "204.099999999999994", "兑换金额": "0", "商品编号": "00280"}, {"单价": "25", "商品": "日本白蛋10只", "序号": "51", "数量": "8", "笔数": "8", "金额": "200", "兑换金额": "0", "商品编号": "00217"}, {"单价": "6.1", "商品": "聖女果300g", "序号": "52", "数量": "32.4588", "笔数": "31", "金额": "198", "兑换金额": "0", "商品编号": "00392"}, {"单价": "9", "商品": "大牛油果", "序号": "53", "数量": "21.4445", "笔数": "6", "金额": "193", "兑换金额": "0", "商品编号": "00486"}, {"单价": "6.6003", "商品": "番茄350g", "序号": "54", "数量": "29.1655", "笔数": "31", "金额": "192.5", "兑换金额": "0", "商品编号": "00089"}, {"单价": "9.1429", "商品": "鹽水花生", "序号": "55", "数量": "21", "笔数": "17", "金额": "192", "兑换金额": "0", "商品编号": "00470"}, {"单价": "7.6729", "商品": "菜心苗300g", "序号": "56", "数量": "24.7625", "笔数": "17", "金额": "190", "兑换金额": "0", "商品编号": "00022"}, {"单价": "41.9998", "商品": "沙鑽魚", "序号": "57", "数量": "4.4905", "笔数": "8", "金额": "188.59999999999999", "兑换金额": "0", "商品编号": "00668"}, {"单价": "17.2993", "商品": "串茄198g", "序号": "58", "数量": "10.8097", "笔数": "10", "金额": "187", "兑换金额": "0", "商品编号": "00309"}, {"单价": "9", "商品": "牛奶蕉", "序号": "59", "数量": "20.3445", "笔数": "13", "金额": "183.099999999999994", "兑换金额": "0", "商品编号": "00468"}, {"单价": "34.9994", "商品": "豬潤", "序号": "60", "数量": "5.1258", "笔数": "10", "金额": "179.40000000000001", "兑换金额": "0", "商品编号": "00268"}, {"单价": "72.00060000000000571", "商品": "文昌雞1.1-1.3KG", "序号": "61", "数量": "2.4722", "笔数": "2", "金额": "178", "兑换金额": "0", "商品编号": "00319"}, {"单价": "7.5", "商品": "辣椒(杭椒)250g", "序号": "62", "数量": "23", "笔数": "16", "金额": "172.5", "兑换金额": "0", "商品编号": "00111"}, {"单价": "6.9526", "商品": "上海青300g", "序号": "63", "数量": "24.6814", "笔数": "33", "金额": "171.59999999999999", "兑换金额": "0", "商品编号": "00018"}, {"单价": "40", "商品": "大頭魚", "序号": "64", "数量": "4.27", "笔数": "5", "金额": "170.80000000000001", "兑换金额": "0", "商品编号": "00289"}, {"单价": "8.8999", "商品": "玉米(甜)", "序号": "65", "数量": "18.899", "笔数": "26", "金额": "168.19999999999999", "兑换金额": "0", "商品编号": "00033"}, {"单价": "4.1001", "商品": "小土豆400g", "序号": "66", "数量": "40.9016", "笔数": "31", "金额": "167.69999999999999", "兑换金额": "0", "商品编号": "00096"}, {"单价": "16.5998", "商品": "三色彩椒550g", "序号": "67", "数量": "9.8736", "笔数": "11", "金额": "163.90000000000001", "兑换金额": "0", "商品编号": "00112"}, {"单价": "23.2558", "商品": "蘆筍200g", "序号": "68", "数量": "6.88", "笔数": "10", "金额": "160", "兑换金额": "0", "商品编号": "00050"}, {"单价": "7.3968", "商品": "黄秋葵200g", "序号": "69", "数量": "20.8198", "笔数": "20", "金额": "154", "兑换金额": "0", "商品编号": "00088"}, {"单价": "7", "商品": "百福蒸煮豆腐350ml/盒", "序号": "70", "数量": "22", "笔数": "19", "金额": "154", "兑换金额": "0", "商品编号": "00189"}, {"单价": "9.4999", "商品": "油麥菜苗250g", "序号": "71", "数量": "15.9159", "笔数": "20", "金额": "151.19999999999999", "兑换金额": "0", "商品编号": "00304"}, {"单价": "5.9", "商品": "地瓜葉300g", "序号": "72", "数量": "25.1694", "笔数": "24", "金额": "148.5", "兑换金额": "0", "商品编号": "00077"}, {"单价": "52.014699999999998", "商品": "肉眼（肉扒）", "序号": "73", "数量": "2.8242", "笔数": "4", "金额": "146.90000000000001", "兑换金额": "0", "商品编号": "00273"}, {"单价": "9.5004", "商品": "大紅椒250g", "序号": "74", "数量": "15.2099", "笔数": "4", "金额": "144.5", "兑换金额": "0", "商品编号": "00109"}, {"单价": "12.6004", "商品": "甜豆300g", "序号": "75", "数量": "11.4282", "笔数": "17", "金额": "144", "兑换金额": "0", "商品编号": "00039"}, {"单价": "37.9987", "商品": "竹絲雞（小 ）0.9-1.0KG", "序号": "76", "数量": "3.7896", "笔数": "4", "金额": "144", "兑换金额": "0", "商品编号": "00316"}, {"单价": "12", "商品": "菠蘿", "序号": "77", "数量": "12", "笔数": "12", "金额": "144", "兑换金额": "0", "商品编号": "00439"}, {"单价": "4.1002", "商品": "珠蔥150g", "序号": "78", "数量": "34.2914", "笔数": "31", "金额": "140.59999999999999", "兑换金额": "0", "商品编号": "00067"}, {"单价": "8.2997", "商品": "娃娃菜（三個装）", "序号": "79", "数量": "16.868", "笔数": "20", "金额": "140", "兑换金额": "0", "商品编号": "00001"}, {"单价": "4.4", "商品": "冬瓜", "序号": "80", "数量": "31.7046", "笔数": "22", "金额": "139.5", "兑换金额": "0", "商品编号": "00023"}, {"单价": "29.9996", "商品": "星鱸", "序号": "81", "数量": "4.6434", "笔数": "5", "金额": "139.30000000000001", "兑换金额": "0", "商品编号": "00226"}, {"单价": "5.7999", "商品": "湖南椒250g", "序号": "82", "数量": "23.7075", "笔数": "16", "金额": "137.5", "兑换金额": "0", "商品编号": "00065"}, {"单价": "8.5", "商品": "豆蔔1份", "序号": "83", "数量": "16", "笔数": "15", "金额": "136", "兑换金额": "0", "商品编号": "00194"}, {"单价": "6.8", "商品": "攸縣香干200g/袋", "序号": "84", "数量": "20", "笔数": "20", "金额": "136", "兑换金额": "0", "商品编号": "00342"}, {"单价": "20.3191", "商品": "枇杷", "序号": "85", "数量": "6.644", "笔数": "6", "金额": "135", "兑换金额": "0", "商品编号": "00395"}, {"单价": "8.9002", "商品": "荷蘭豆200g", "序号": "86", "数量": "14.9435", "笔数": "16", "金额": "133", "兑换金额": "0", "商品编号": "00037"}, {"单价": "13.9374", "商品": "鮮淮山", "序号": "87", "数量": "9.5355", "笔数": "9", "金额": "132.90000000000001", "兑换金额": "0", "商品编号": "00095"}, {"单价": "8.1843", "商品": "菜心300g", "序号": "88", "数量": "15.8841", "笔数": "15", "金额": "130", "兑换金额": "0", "商品编号": "00021"}, {"单价": "12.2002", "商品": "板栗肉200g", "序号": "89", "数量": "10.6392", "笔数": "11", "金额": "129.80000000000001", "兑换金额": "0", "商品编号": "00038"}, {"单价": "10.887", "商品": "福建花(散花）", "序号": "90", "数量": "11.7204", "笔数": "14", "金额": "127.59999999999999", "兑换金额": "0", "商品编号": "00386"}, {"单价": "25", "商品": "羅非魚", "序号": "91", "数量": "5.084", "笔数": "6", "金额": "127.099999999999994", "兑换金额": "0", "商品编号": "00292"}, {"单价": "7.0001", "商品": "指天椒100g", "序号": "92", "数量": "18.071100000000001", "笔数": "22", "金额": "126.5", "兑换金额": "0", "商品编号": "00108"}, {"单价": "3.4001", "商品": "金針菇200g", "序号": "93", "数量": "36.8808", "笔数": "24", "金额": "125.40000000000001", "兑换金额": "0", "商品编号": "00100"}, {"单价": "7.8", "商品": "南瓜(貝貝南瓜)", "序号": "94", "数量": "15.8206", "笔数": "16", "金额": "123.40000000000001", "兑换金额": "0", "商品编号": "00085"}, {"单价": "7.7", "商品": "西芹", "序号": "95", "数量": "15.7012", "笔数": "30", "金额": "120.90000000000001", "兑换金额": "0", "商品编号": "00069"}, {"单价": "103.4808", "商品": "梅頭瘦肉", "序号": "96", "数量": "1.1664", "笔数": "3", "金额": "120.7", "兑换金额": "0", "商品编号": "00283"}, {"单价": "5.1", "商品": "辣椒(螺絲椒)250g", "序号": "97", "数量": "23.5296", "笔数": "15", "金额": "120", "兑换金额": "0", "商品编号": "00064"}, {"单价": "4.0998", "商品": "綠豆芽300g", "序号": "98", "数量": "29.0258", "笔数": "31", "金额": "119", "兑换金额": "0", "商品编号": "00055"}, {"单价": "9.1649", "商品": "學鬥白菜300g", "序号": "99", "数量": "12.9298", "笔数": "14", "金额": "118.5", "兑换金额": "0", "商品编号": "00390"}, {"单价": "49.1776", "商品": "白倉魚", "序号": "100", "数量": "2.4015", "笔数": "4", "金额": "118.099999999999994", "兑换金额": "0", "商品编号": "00667"}, {"单价": "4.3607", "商品": "白蘿蔔", "序号": "101", "数量": "26.4864", "笔数": "23", "金额": "115.5", "兑换金额": "0", "商品编号": "00045"}, {"单价": "9.8995", "商品": "大蔥", "序号": "102", "数量": "11.6066", "笔数": "16", "金额": "114.90000000000001", "兑换金额": "0", "商品编号": "00068"}, {"单价": "8.6348", "商品": "毛瓜", "序号": "103", "数量": "13.0518", "笔数": "16", "金额": "112.7", "兑换金额": "0", "商品编号": "00083"}, {"单价": "11.2999", "商品": "毛豆500g", "序号": "104", "数量": "9.9558", "笔数": "8", "金额": "112.5", "兑换金额": "0", "商品编号": "00092"}, {"单价": "5", "商品": "小旺菜", "序号": "105", "数量": "22.46", "笔数": "17", "金额": "112.3", "兑换金额": "0", "商品编号": "00004"}, {"单价": "3.9205", "商品": "木耳200g", "序号": "106", "数量": "27.8536", "笔数": "3", "金额": "109.2", "兑换金额": "0", "商品编号": "00062"}, {"单价": "10.7001", "商品": "四季豆450g", "序号": "107", "数量": "9.813", "笔数": "10", "金额": "105", "兑换金额": "0", "商品编号": "00034"}, {"单价": "7.8997", "商品": "冬菇200g", "序号": "108", "数量": "13.2916", "笔数": "13", "金额": "105", "兑换金额": "0", "商品编号": "00101"}, {"单价": "10.6003", "商品": "馬蹄500g", "序号": "109", "数量": "9.8582", "笔数": "11", "金额": "104.5", "兑换金额": "0", "商品编号": "00041"}, {"单价": "7.1", "商品": "紅菜頭", "序号": "110", "数量": "14.6901", "笔数": "14", "金额": "104.3", "兑换金额": "0", "商品编号": "00048"}, {"单价": "60.4825", "商品": "五花腩", "序号": "111", "数量": "1.7162", "笔数": "2", "金额": "103.8", "兑换金额": "0", "商品编号": "00284"}, {"单价": "13.6999", "商品": "粉葛", "序号": "112", "数量": "7.5037", "笔数": "6", "金额": "102.8", "兑换金额": "0", "商品编号": "00060"}, {"单价": "10.3352", "商品": "椰菜花(白花菜)", "序号": "113", "数量": "9.9369", "笔数": "10", "金额": "102.7", "兑换金额": "0", "商品编号": "00011"}, {"单价": "5.8", "商品": "胡蘿蔔(泥紅蘿蔔)", "序号": "114", "数量": "17.1379", "笔数": "27", "金额": "99.40000000000001", "兑换金额": "0", "商品编号": "00046"}, {"单价": "8.8999", "商品": "糖心蜜薯", "序号": "115", "数量": "10.9327", "笔数": "10", "金额": "97.3", "兑换金额": "0", "商品编号": "00093"}, {"单价": "97.9996", "商品": "飛排", "序号": "116", "数量": "0.9898", "笔数": "2", "金额": "97", "兑换金额": "0", "商品编号": "00279"}, {"单价": "8", "商品": "百福硬豆腐340g/盒", "序号": "117", "数量": "12", "笔数": "8", "金额": "96", "兑换金额": "0", "商品编号": "00188"}, {"单价": "7.9", "商品": "小咖啡菇200g", "序号": "118", "数量": "12", "笔数": "11", "金额": "94.8", "兑换金额": "0", "商品编号": "00118"}, {"单价": "6.2971", "商品": "油麥菜300g", "序号": "119", "数量": "14.864", "笔数": "18", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00020"}, {"单价": "8.7957", "商品": "秀珍菇150g", "序号": "120", "数量": "10.6416", "笔数": "11", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00322"}, {"单价": "8.2996", "商品": "毛豆仁200g", "序号": "121", "数量": "11.2776", "笔数": "9", "金额": "93.59999999999999", "兑换金额": "0", "商品编号": "00372"}, {"单价": "8.5", "商品": "上海水餃皮（白圓皮）350g", "序号": "122", "数量": "11", "笔数": "9", "金额": "93.5", "兑换金额": "0", "商品编号": "00206"}, {"单价": "8.5", "商品": "長水瓜", "序号": "123", "数量": "10.8353", "笔数": "13", "金额": "92.099999999999994", "兑换金额": "0", "商品编号": "00031"}, {"单价": "88.0031000000000034", "商品": "豬展", "序号": "124", "数量": "1.0261", "笔数": "3", "金额": "90.3", "兑换金额": "0", "商品编号": "00263"}, {"单价": "7.5679", "商品": "雞毛菜300g", "序号": "125", "数量": "11.8924", "笔数": "7", "金额": "90", "兑换金额": "0", "商品编号": "00327"}, {"单价": "10.5", "商品": "蓮藕", "序号": "126", "数量": "8.4095", "笔数": "9", "金额": "88.3", "兑换金额": "0", "商品编号": "00094"}, {"单价": "13.0063999999999993", "商品": "鮮鐵棍淮山", "序号": "127", "数量": "6.7582", "笔数": "8", "金额": "87.90000000000001", "兑换金额": "0", "商品编号": "00049"}, {"单价": "3.5999", "商品": "芹菜150g", "序号": "128", "数量": "23.334", "笔数": "23", "金额": "84", "兑换金额": "0", "商品编号": "00119"}, {"单价": "42", "商品": "豬肚（個）", "序号": "129", "数量": "2", "笔数": "2", "金额": "84", "兑换金额": "0", "商品编号": "00251"}, {"单价": "12", "商品": "鵪鶉蛋", "序号": "130", "数量": "7", "笔数": "7", "金额": "84", "兑换金额": "0", "商品编号": "00564"}, {"单价": "5.8", "商品": "洋蔥(紅)", "序号": "131", "数量": "14.2759", "笔数": "15", "金额": "82.8", "兑换金额": "0", "商品编号": "00074"}, {"单价": "77.99939999999999", "商品": "排骨頭", "序号": "132", "数量": "1.0577", "笔数": "1", "金额": "82.5", "兑换金额": "0", "商品编号": "00260"}, {"单价": "7.5131", "商品": "萵筍", "序号": "133", "数量": "10.9409", "笔数": "14", "金额": "82.2", "兑换金额": "0", "商品编号": "00325"}, {"单价": "6.0001", "商品": "富士苹果", "序号": "134", "数量": "13.3332", "笔数": "3", "金额": "80", "兑换金额": "0", "商品编号": "00427"}, {"单价": "12.2033", "商品": "金奇異果", "序号": "135", "数量": "6.5556", "笔数": "2", "金额": "80", "兑换金额": "0", "商品编号": "00556"}, {"单价": "6.4869", "商品": "韭王150g", "序号": "136", "数量": "12.0243", "笔数": "11", "金额": "78", "兑换金额": "0", "商品编号": "00070"}, {"单价": "12.6", "商品": "百合四頭", "序号": "137", "数量": "6", "笔数": "6", "金额": "75.59999999999999", "兑换金额": "0", "商品编号": "00362"}, {"单价": "5.4999", "商品": "羽衣甘藍150g", "序号": "138", "数量": "13.6365", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00009"}, {"单价": "9.2891", "商品": "茼蒿300g", "序号": "139", "数量": "8.074", "笔数": "9", "金额": "75", "兑换金额": "0", "商品编号": "00401"}, {"单价": "62.003300000000003", "商品": "西施", "序号": "140", "数量": "1.208", "笔数": "2", "金额": "74.90000000000001", "兑换金额": "0", "商品编号": "00287"}, {"单价": "4.7", "商品": "大白菜", "序号": "141", "数量": "15.4682", "笔数": "8", "金额": "72.7", "兑换金额": "0", "商品编号": "00003"}, {"单价": "8", "商品": "佛手瓜", "序号": "142", "数量": "9.0375", "笔数": "12", "金额": "72.3", "兑换金额": "0", "商品编号": "00040"}, {"单价": "4.8", "商品": "杭白菜300g", "序号": "143", "数量": "15", "笔数": "1", "金额": "72", "兑换金额": "0", "商品编号": "00076"}, {"单价": "9", "商品": "鹹蛋4只", "序号": "144", "数量": "8", "笔数": "8", "金额": "72", "兑换金额": "0", "商品编号": "00147"}, {"单价": "8.2996", "商品": "豌豆仁200g", "序号": "145", "数量": "8.4582", "笔数": "9", "金额": "70.2", "兑换金额": "0", "商品编号": "00373"}, {"单价": "9.2998", "商品": "真空淮山肉300g", "序号": "146", "数量": "7.312", "笔数": "7", "金额": "68", "兑换金额": "0", "商品编号": "00312"}, {"单价": "6.7", "商品": "攸縣白干200g/袋", "序号": "147", "数量": "10", "笔数": "8", "金额": "67", "兑换金额": "0", "商品编号": "00341"}, {"单价": "7.6", "商品": "紫椰菜", "序号": "148", "数量": "8.6316", "笔数": "6", "金额": "65.59999999999999", "兑换金额": "0", "商品编号": "00008"}, {"单价": "48.3619", "商品": "豬展骨", "序号": "149", "数量": "1.3461", "笔数": "2", "金额": "65.099999999999994", "兑换金额": "0", "商品编号": "00246"}, {"单价": "11.522", "商品": "皇帝菜苗300g", "序号": "150", "数量": "5.6414", "笔数": "9", "金额": "65", "兑换金额": "0", "商品编号": "00324"}, {"单价": "6.1001", "商品": "芋仔300g", "序号": "151", "数量": "10.6392", "笔数": "8", "金额": "64.90000000000001", "兑换金额": "0", "商品编号": "00097"}, {"单价": "9.2", "商品": "玉米筍200g", "序号": "152", "数量": "7", "笔数": "7", "金额": "64.40000000000001", "兑换金额": "0", "商品编号": "00032"}, {"单价": "8.9004", "商品": "紫薯500g", "序号": "153", "数量": "7.1008", "笔数": "8", "金额": "63.2", "兑换金额": "0", "商品编号": "00387"}, {"单价": "7.9", "商品": "人參白薯", "序号": "154", "数量": "8", "笔数": "6", "金额": "63.2", "兑换金额": "0", "商品编号": "00497"}, {"单价": "61.9996", "商品": "脊骨", "序号": "155", "数量": "0.9742", "笔数": "1", "金额": "60.4", "兑换金额": "0", "商品编号": "00264"}, {"单价": "10.4004", "商品": "鮮蘑菇(咖啡菇)200g", "序号": "156", "数量": "5.769", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00105"}, {"单价": "5.9999", "商品": "沙糖桔", "序号": "157", "数量": "10.00019999999999953", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00369"}, {"单价": "2.5", "商品": "百香果", "序号": "158", "数量": "24", "笔数": "2", "金额": "60", "兑换金额": "0", "商品编号": "00443"}, {"单价": "14.9993", "商品": "油柑", "序号": "159", "数量": "4.00020000000000042", "笔数": "6", "金额": "60", "兑换金额": "0", "商品编号": "00494"}, {"单价": "11.9995", "商品": "小青瓜400g", "序号": "160", "数量": "4.7502", "笔数": "6", "金额": "57", "兑换金额": "0", "商品编号": "00024"}, {"单价": "8", "商品": "河粉（炒粉）350g", "序号": "161", "数量": "7", "笔数": "6", "金额": "56", "兑换金额": "0", "商品编号": "00212"}, {"单价": "6.3", "商品": "西葫蘆瓜", "序号": "162", "数量": "8.8413", "笔数": "6", "金额": "55.7", "兑换金额": "0", "商品编号": "00028"}, {"单价": "4.4", "商品": "南瓜", "序号": "163", "数量": "12.3864", "笔数": "12", "金额": "54.5", "兑换金额": "0", "商品编号": "00026"}, {"单价": "5.8", "商品": "杏鮑菇200g", "序号": "164", "数量": "9", "笔数": "9", "金额": "52.2", "兑换金额": "0", "商品编号": "00102"}, {"单价": "9.7998", "商品": "糯粟米", "序号": "165", "数量": "5.296", "笔数": "5", "金额": "51.9", "兑换金额": "0", "商品编号": "00091"}, {"单价": "8.5", "商品": "上海麵350g", "序号": "166", "数量": "6", "笔数": "5", "金额": "51", "兑换金额": "0", "商品编号": "00148"}, {"单价": "27.9996", "商品": "包魚骨", "序号": "167", "数量": "1.8036", "笔数": "2", "金额": "50.5", "兑换金额": "0", "商品编号": "00254"}, {"单价": "8.7997", "商品": "西洋菜300g", "序号": "168", "数量": "5.682", "笔数": "7", "金额": "50", "兑换金额": "0", "商品编号": "00323"}, {"单价": "8.3", "商品": "花生(鮮)300g", "序号": "169", "数量": "6", "笔数": "4", "金额": "49.8", "兑换金额": "0", "商品编号": "00321"}, {"单价": "16.5", "商品": "金裝牛肉丸250g/包", "序号": "170", "数量": "3", "笔数": "3", "金额": "49.5", "兑换金额": "0", "商品编号": "00296"}, {"单价": "9.9", "商品": "一點紅番薯", "序号": "171", "数量": "5", "笔数": "5", "金额": "49.5", "兑换金额": "0", "商品编号": "00656"}, {"单价": "7.6747", "商品": "芥蘭300g", "序号": "172", "数量": "6.2022", "笔数": "6", "金额": "47.6", "兑换金额": "0", "商品编号": "00015"}, {"单价": "5", "商品": "青尖椒250g", "序号": "173", "数量": "9.36", "笔数": "9", "金额": "46.8", "兑换金额": "0", "商品编号": "00066"}, {"单价": "4.0277", "商品": "韭菜150g", "序号": "174", "数量": "11.4706", "笔数": "9", "金额": "46.2", "兑换金额": "0", "商品编号": "00071"}, {"单价": "25.1989", "商品": "香樁150g", "序号": "175", "数量": "1.8096", "笔数": "2", "金额": "45.6", "兑换金额": "0", "商品编号": "00155"}, {"单价": "9", "商品": "雲吞麵（幼）350g", "序号": "176", "数量": "5", "笔数": "5", "金额": "45", "兑换金额": "0", "商品编号": "00208"}, {"单价": "15", "商品": "招牌叉燒包 120g*4個", "序号": "177", "数量": "3", "笔数": "3", "金额": "45", "兑换金额": "0", "商品编号": "00537"}, {"单价": "6.8", "商品": "竹蔗", "序号": "178", "数量": "6.5441", "笔数": "4", "金额": "44.5", "兑换金额": "0", "商品编号": "00058"}, {"单价": "8.9", "商品": "蒜心300g", "序号": "179", "数量": "5", "笔数": "5", "金额": "44.5", "兑换金额": "0", "商品编号": "00072"}, {"单价": "8.6", "商品": "香素雞200g/袋", "序号": "180", "数量": "5", "笔数": "4", "金额": "43", "兑换金额": "0", "商品编号": "00343"}, {"单价": "5.7", "商品": "蒲瓜", "序号": "181", "数量": "7.421", "笔数": "6", "金额": "42.3", "兑换金额": "0", "商品编号": "00027"}, {"单价": "5.3999", "商品": "青蘿蔔", "序号": "182", "数量": "7.6483", "笔数": "10", "金额": "41.3", "兑换金额": "0", "商品编号": "00043"}, {"单价": "8.3999", "商品": "水果蘿蔔", "序号": "183", "数量": "4.8929", "笔数": "8", "金额": "41.1", "兑换金额": "0", "商品编号": "00044"}, {"单价": "5.2999", "商品": "青木瓜", "序号": "184", "数量": "7.7548", "笔数": "6", "金额": "41.1", "兑换金额": "0", "商品编号": "00113"}, {"单价": "5.5811", "商品": "黃皮椒250g", "序号": "185", "数量": "7.2746", "笔数": "4", "金额": "40.6", "兑换金额": "0", "商品编号": "00063"}, {"单价": "7.7", "商品": "沙葛", "序号": "186", "数量": "5.1948", "笔数": "6", "金额": "40", "兑换金额": "0", "商品编号": "00057"}, {"单价": "10", "商品": "果凍橙", "序号": "187", "数量": "4", "笔数": "2", "金额": "40", "兑换金额": "0", "商品编号": "00131"}, {"单价": "8", "商品": "油麵350g", "序号": "188", "数量": "5", "笔数": "3", "金额": "40", "兑换金额": "0", "商品编号": "00204"}, {"单价": "7.6", "商品": "茅根150g", "序号": "189", "数量": "5", "笔数": "5", "金额": "38", "兑换金额": "0", "商品编号": "00099"}, {"单价": "9.2002", "商品": "黃金蜜薯500g", "序号": "190", "数量": "3.826", "笔数": "2", "金额": "35.2", "兑换金额": "0", "商品编号": "00132"}, {"单价": "4", "商品": "黃豆芽300g", "序号": "191", "数量": "8.75", "笔数": "9", "金额": "35", "兑换金额": "0", "商品编号": "00056"}, {"单价": "48.001100000000001", "商品": "瘦肉", "序号": "192", "数量": "0.7104", "笔数": "1", "金额": "34.1", "兑换金额": "0", "商品编号": "00276"}, {"单价": "77.99120000000001", "商品": "骨腩", "序号": "193", "数量": "0.4321", "笔数": "1", "金额": "33.7", "兑换金额": "0", "商品编号": "00285"}, {"单价": "6.7", "商品": "客家豆腐380g/盒", "序号": "194", "数量": "5", "笔数": "5", "金额": "33.5", "兑换金额": "0", "商品编号": "00340"}, {"单价": "5", "商品": "肥肉", "序号": "195", "数量": "6.64", "笔数": "2", "金额": "33.2", "兑换金额": "0", "商品编号": "00258"}, {"单价": "7.5998", "商品": "水東芥菜450g", "序号": "196", "数量": "4.3422", "笔数": "6", "金额": "33", "兑换金额": "0", "商品编号": "00013"}, {"单价": "8", "商品": "豬腰（個）", "序号": "197", "数量": "4", "笔数": "1", "金额": "32", "兑换金额": "0", "商品编号": "00256"}, {"单价": "88", "商品": "排骨粒", "序号": "198", "数量": "0.3625", "笔数": "1", "金额": "31.9", "兑换金额": "0", "商品编号": "00272"}, {"单价": "3.7002", "商品": "枸杞葉180g", "序号": "199", "数量": "8.5131", "笔数": "9", "金额": "31.5", "兑换金额": "0", "商品编号": "00082"}, {"单价": "88.011300000000006", "商品": "有筋腱", "序号": "200", "数量": "0.3545", "笔数": "1", "金额": "31.2", "兑换金额": "0", "商品编号": "00274"}, {"单价": "4.8", "商品": "大平包", "序号": "201", "数量": "6.25", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00010"}, {"单价": "5.9601", "商品": "蟹味菇150g", "序号": "202", "数量": "5.0335", "笔数": "5", "金额": "30", "兑换金额": "0", "商品编号": "00103"}, {"单价": "11.3999", "商品": "西椒550g", "序号": "203", "数量": "2.6316", "笔数": "3", "金额": "30", "兑换金额": "0", "商品编号": "00110"}, {"单价": "15", "商品": "奶白饅頭45g*12個", "序号": "204", "数量": "2", "笔数": "2", "金额": "30", "兑换金额": "0", "商品编号": "00145"}, {"单价": "6.2001", "商品": "海帶結200g", "序号": "205", "数量": "4.758", "笔数": "4", "金额": "29.5", "兑换金额": "0", "商品编号": "00364"}, {"单价": "9.6598", "商品": "芒果", "序号": "206", "数量": "3.0125", "笔数": "2", "金额": "29.1", "兑换金额": "0", "商品编号": "00406"}, {"单价": "37.9981", "商品": "豬粉腸", "序号": "207", "数量": "0.7553", "笔数": "2", "金额": "28.7", "兑换金额": "0", "商品编号": "00248"}, {"单价": "67.99209999999999", "商品": "梅頭豬扒", "序号": "208", "数量": "0.4074", "笔数": "1", "金额": "27.7", "兑换金额": "0", "商品编号": "00270"}, {"单价": "6.1003", "商品": "盒裝豆苗200g", "序号": "209", "数量": "4.508", "笔数": "2", "金额": "27.5", "兑换金额": "0", "商品编号": "00054"}, {"单价": "9", "商品": "皮蛋4只", "序号": "210", "数量": "3", "笔数": "3", "金额": "27", "兑换金额": "0", "商品编号": "00146"}, {"单价": "5.3", "商品": "蒜苗150g", "序号": "211", "数量": "5", "笔数": "3", "金额": "26.5", "兑换金额": "0", "商品编号": "00120"}, {"单价": "6.4358", "商品": "白玉菇150g", "序号": "212", "数量": "4.0399", "笔数": "5", "金额": "26", "兑换金额": "0", "商品编号": "00104"}, {"单价": "8.5", "商品": "上海雲吞皮（白方皮）350g", "序号": "213", "数量": "3", "笔数": "3", "金额": "25.5", "兑换金额": "0", "商品编号": "00207"}, {"单价": "5", "商品": "紫蘇150g", "序号": "214", "数量": "5", "笔数": "4", "金额": "25", "兑换金额": "0", "商品编号": "00121"}, {"单价": "1", "商品": "膠袋", "序号": "215", "数量": "25", "笔数": "24", "金额": "25", "兑换金额": "0", "商品编号": "00300"}, {"单价": "12.5", "商品": "盒裝枇杷", "序号": "216", "数量": "2", "笔数": "1", "金额": "25", "兑换金额": "0", "商品编号": "00543"}, {"单价": "5.7", "商品": "銀絲王300g", "序号": "217", "数量": "4.2105", "笔数": "5", "金额": "24", "兑换金额": "0", "商品编号": "00005"}, {"单价": "14.069599999999999", "商品": "豬耳2只", "序号": "218", "数量": "1.7058", "笔数": "2", "金额": "24", "兑换金额": "0", "商品编号": "00261"}, {"单价": "10.4998", "商品": "西蘭花苗200g", "序号": "219", "数量": "2.1429", "笔数": "2", "金额": "22.5", "兑换金额": "0", "商品编号": "00370"}, {"单价": "5.5", "商品": "綠九芽生菜300g", "序号": "220", "数量": "4", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00078"}, {"单价": "4.8001", "商品": "鮮蘑菇(海鮮菇)250g", "序号": "221", "数量": "4.5832", "笔数": "4", "金额": "22", "兑换金额": "0", "商品编号": "00106"}, {"单价": "7", "商品": "雪蓮果", "序号": "222", "数量": "3", "笔数": "2", "金额": "21", "兑换金额": "0", "商品编号": "00330"}, {"单价": "10", "商品": "豬心（個）", "序号": "223", "数量": "2", "笔数": "1", "金额": "20", "兑换金额": "0", "商品编号": "00249"}, {"单价": "10", "商品": "青梅", "序号": "224", "数量": "2", "笔数": "2", "金额": "20", "兑换金额": "0", "商品编号": "00674"}, {"单价": "9.5", "商品": "蝦米腸粉", "序号": "225", "数量": "2", "笔数": "2", "金额": "19", "兑换金额": "0", "商品编号": "00202"}, {"单价": "18", "商品": "豬利（條）", "序号": "226", "数量": "1", "笔数": "1", "金额": "18", "兑换金额": "0", "商品编号": "00250"}, {"单价": "8", "商品": "拉麵350g", "序号": "227", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00151"}, {"单价": "8", "商品": "白腸粉", "序号": "228", "数量": "2", "笔数": "2", "金额": "16", "兑换金额": "0", "商品编号": "00203"}, {"单价": "15.5", "商品": "蔥香手抓餅97g*4片", "序号": "229", "数量": "1", "笔数": "1", "金额": "15.5", "兑换金额": "0", "商品编号": "00417"}, {"单价": "15", "商品": "馬鮫魚丸250g/包", "序号": "230", "数量": "1", "笔数": "1", "金额": "15", "兑换金额": "0", "商品编号": "00354"}, {"单价": "10", "商品": "隔山", "序号": "231", "数量": "1.48", "笔数": "1", "金额": "14.8", "兑换金额": "0", "商品编号": "00240"}, {"单价": "12.00050000000000061", "商品": "大青芒", "序号": "232", "数量": "0.8333", "笔数": "1", "金额": "10", "兑换金额": "0", "商品编号": "00493"}, {"单价": "5.2997", "商品": "魚腥草150g", "序号": "233", "数量": "1.6982", "笔数": "2", "金额": "9", "兑换金额": "0", "商品编号": "00059"}, {"单价": "8.4005", "商品": "板栗番薯", "序号": "234", "数量": "0.869", "笔数": "1", "金额": "7.3", "兑换金额": "0", "商品编号": "00042"}, {"单价": "11", "商品": "儿菜", "序号": "235", "数量": "0.6", "笔数": "1", "金额": "6.6", "兑换金额": "0", "商品编号": "00655"}, {"单价": "4.4", "商品": "沙薑100g", "序号": "236", "数量": "0.9091", "笔数": "1", "金额": "4", "兑换金额": "0", "商品编号": "00115"}, {"单价": "5.7001", "商品": "紅蔥頭（吊幹蔥)100g", "序号": "237", "数量": "0.6842", "笔数": "1", "金额": "3.9", "兑换金额": "0", "商品编号": "00114"}]	{"items": [], "summary": "AI分析失败"}	2026-03-31 22:16:18	2026-03-31 22:16:18
4	1	12	KyXvGtQKFNlWc1eb3f004e560cdeccaac0e969486e4e.png	sales_uploads/1/20260531_054751_KyXvGtQKFNlWc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31	0	0	0	0	\N	\N	{"items": [], "summary": "AI识别失败"}	2026-05-31 05:47:51	2026-05-31 05:47:52
5	1	12	1MpJ7D8-iVicc1eb3f004e560cdeccaac0e969486e4e.png	sales_uploads/1/20260531_054807_1MpJ7D8-iVicc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31	0	0	0	0	\N	\N	{"items": [], "summary": "AI识别失败"}	2026-05-31 05:48:07	2026-05-31 05:48:08
6	1	12	IG4zy-wp6vagc1eb3f004e560cdeccaac0e969486e4e.png	sales_uploads/1/20260531_055318_IG4zy-wp6vagc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31	0	0	0	0	\N	\N	{"items": [{"qty": 24, "unit": "斤", "amount": 84, "product_name": "菠菜"}, {"qty": 32, "unit": "斤", "amount": 64, "product_name": "胡萝卜"}, {"qty": 18, "unit": "斤", "amount": 27, "product_name": "苹果"}, {"qty": 12, "unit": "斤", "amount": 72, "product_name": "鸡肉"}, {"qty": 8, "unit": "斤", "amount": 20, "product_name": "面包"}, {"qty": 24, "unit": "斤", "amount": 96, "product_name": "鸡蛋"}], "summary": "简短说明：共识别6个商品，图片类型为销售汇总表截图。"}	2026-05-31 05:53:18	2026-05-31 05:53:28
7	1	12	ZyyA0gOlFweRc1eb3f004e560cdeccaac0e969486e4e.png	sales_uploads/1/20260531_055807_ZyyA0gOlFweRc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31	0	0	0	0	\N	\N	{"items": [{"qty": 24, "unit": "斤", "amount": 84, "product_name": "菠菜"}, {"qty": 32, "unit": "斤", "amount": 64, "product_name": "胡萝卜"}, {"qty": 18, "unit": "斤", "amount": 27, "product_name": "苹果"}, {"qty": 12, "unit": "斤", "amount": 72, "product_name": "鸡肉"}, {"qty": 8, "unit": "斤", "amount": 20, "product_name": "面包"}, {"qty": 24, "unit": "斤", "amount": 96, "product_name": "鸡蛋"}], "summary": "简短说明：共识别6个商品，图片类型为销售汇总表。"}	2026-05-31 05:58:07	2026-05-31 05:58:17
8	1	12	gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	sales_uploads/1/20260531_055905_gUrVLbmZyLMnc1eb3f004e560cdeccaac0e969486e4e.png	2026-05-31	2	0	6	0	\N	\N	{"items": [{"qty": 24, "unit": "斤", "amount": 84, "product_name": "菠菜"}, {"qty": 32, "unit": "斤", "amount": 64, "product_name": "胡萝卜"}, {"qty": 18, "unit": "斤", "amount": 27, "product_name": "苹果"}, {"qty": 12, "unit": "斤", "amount": 72, "product_name": "鸡肉"}, {"qty": 8, "unit": "斤", "amount": 20, "product_name": "面包"}, {"qty": 24, "unit": "斤", "amount": 96, "product_name": "鸡蛋"}], "summary": "简短说明：共识别6个商品，识别到的图片类型为销售汇总表截图。"}	2026-05-31 05:59:05	2026-05-31 06:08:34
9	1	8	零售报表分析-零售-零售汇总_1774399133339.xlsx	sales_uploads/1/20260603_204521_零售报表分析-零售-零售汇总_1774399133339.xlsx	2026-06-03	2	237	50	0	\N	[{"\\u5e8f\\u53f7":"1","\\u5546\\u54c1":"\\u8c6c\\u8089100\\u5143","\\u5546\\u54c1\\u7f16\\u53f7":"10000","\\u6570\\u91cf":"77.3","\\u5355\\u4ef7":"97.9948","\\u91d1\\u989d":"7575","\\u7b14\\u6570":"87","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"2","\\u5546\\u54c1":"\\u8019\\u8019\\u67d1","\\u5546\\u54c1\\u7f16\\u53f7":"00195","\\u6570\\u91cf":"103.5702","\\u5355\\u4ef7":"6.8939","\\u91d1\\u989d":"714","\\u7b14\\u6570":"29","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"3","\\u5546\\u54c1":"\\u6e05\\u9060\\u96de1.1-1.3KG","\\u5546\\u54c1\\u7f16\\u53f7":"00173","\\u6570\\u91cf":"10.8384","\\u5355\\u4ef7":"62.0018000000000029","\\u91d1\\u989d":"672","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"4","\\u5546\\u54c1":"\\u5730\\u5011\\u9999\\u8549","\\u5546\\u54c1\\u7f16\\u53f7":"00129","\\u6570\\u91cf":"80.629","\\u5355\\u4ef7":"7.9401","\\u91d1\\u989d":"640.20000000000005","\\u7b14\\u6570":"50","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"5","\\u5546\\u54c1":"\\u9ec3\\u82b1\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00223","\\u6570\\u91cf":"10.8525","\\u5355\\u4ef7":"51.4075","\\u91d1\\u989d":"557.89999999999998","\\u7b14\\u6570":"18","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"6","\\u5546\\u54c1":"\\u7d05\\u8525(\\u9999\\u8525)100g","\\u5546\\u54c1\\u7f16\\u53f7":"00306","\\u6570\\u91cf":"135","\\u5355\\u4ef7":"3.5","\\u91d1\\u989d":"472.5","\\u7b14\\u6570":"104","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"7","\\u5546\\u54c1":"\\u897f\\u862d\\u82b1","\\u5546\\u54c1\\u7f16\\u53f7":"00012","\\u6570\\u91cf":"37.9673","\\u5355\\u4ef7":"12.2869","\\u91d1\\u989d":"466.5","\\u7b14\\u6570":"80","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"8","\\u5546\\u54c1":"\\u738b\\u7acb\\u9be7","\\u5546\\u54c1\\u7f16\\u53f7":"00224","\\u6570\\u91cf":"10.5167","\\u5355\\u4ef7":"41.9999","\\u91d1\\u989d":"441.69999999999999","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"9","\\u5546\\u54c1":"\\u6563\\u88dd\\u4e32\\u8304","\\u5546\\u54c1\\u7f16\\u53f7":"00654","\\u6570\\u91cf":"21.545","\\u5355\\u4ef7":"20","\\u91d1\\u989d":"430.89999999999998","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"10","\\u5546\\u54c1":"\\u69b4\\u69e4\\u756a\\u85af500g","\\u5546\\u54c1\\u7f16\\u53f7":"00391","\\u6570\\u91cf":"39.027900000000002","\\u5355\\u4ef7":"10.4003","\\u91d1\\u989d":"405.89999999999998","\\u7b14\\u6570":"35","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"11","\\u5546\\u54c1":"\\u767d\\u8766\\u8089200g","\\u5546\\u54c1\\u7f16\\u53f7":"00154","\\u6570\\u91cf":"20","\\u5355\\u4ef7":"20","\\u91d1\\u989d":"400","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"12","\\u5546\\u54c1":"\\u849c\\u982d220g","\\u5546\\u54c1\\u7f16\\u53f7":"00117","\\u6570\\u91cf":"44","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"396","\\u7b14\\u6570":"38","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"13","\\u5546\\u54c1":"\\u80e1\\u863f\\u8514(\\u7d05\\u863f\\u8514)","\\u5546\\u54c1\\u7f16\\u53f7":"00047","\\u6570\\u91cf":"77.56870000000001","\\u5355\\u4ef7":"5.1","\\u91d1\\u989d":"395.60000000000002","\\u7b14\\u6570":"78","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"14","\\u5546\\u54c1":"\\u4e00\\u5b57\\u6392","\\u5546\\u54c1\\u7f16\\u53f7":"00282","\\u6570\\u91cf":"5.4154","\\u5355\\u4ef7":"71.9984","\\u91d1\\u989d":"389.89999999999998","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"15","\\u5546\\u54c1":"\\u5c0f\\u85cd\\u8393","\\u5546\\u54c1\\u7f16\\u53f7":"00467","\\u6570\\u91cf":"27.6916","\\u5355\\u4ef7":"13.9392","\\u91d1\\u989d":"386","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"16","\\u5546\\u54c1":"\\u9f8d\\u5d17\\u96de","\\u5546\\u54c1\\u7f16\\u53f7":"00649","\\u6570\\u91cf":"7","\\u5355\\u4ef7":"52","\\u91d1\\u989d":"364","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"17","\\u5546\\u54c1":"\\u58eb\\u591a\\u5564\\u68a8","\\u5546\\u54c1\\u7f16\\u53f7":"00404","\\u6570\\u91cf":"11.28","\\u5355\\u4ef7":"31.028400000000001","\\u91d1\\u989d":"350","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"18","\\u5546\\u54c1":"\\u82ad\\u6a02","\\u5546\\u54c1\\u7f16\\u53f7":"00410","\\u6570\\u91cf":"54.2846","\\u5355\\u4ef7":"6.3554","\\u91d1\\u989d":"345","\\u7b14\\u6570":"19","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"19","\\u5546\\u54c1":"\\u8591(\\u751f\\u8591)300g","\\u5546\\u54c1\\u7f16\\u53f7":"00116","\\u6570\\u91cf":"33","\\u5355\\u4ef7":"10.4","\\u91d1\\u989d":"343.19999999999999","\\u7b14\\u6570":"33","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"20","\\u5546\\u54c1":"\\u9bae\\u96de\\u86cb","\\u5546\\u54c1\\u7f16\\u53f7":"00566","\\u6570\\u91cf":"18","\\u5355\\u4ef7":"18","\\u91d1\\u989d":"324","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"21","\\u5546\\u54c1":"\\u82e6\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00025","\\u6570\\u91cf":"23.6087","\\u5355\\u4ef7":"13.4866","\\u91d1\\u989d":"318.39999999999998","\\u7b14\\u6570":"55","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"22","\\u5546\\u54c1":"\\u5510\\u751f\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00079","\\u6570\\u91cf":"54.4644","\\u5355\\u4ef7":"5.8001","\\u91d1\\u989d":"315.89999999999998","\\u7b14\\u6570":"66","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"23","\\u5546\\u54c1":"\\u4e09\\u9ec3\\u96de","\\u5546\\u54c1\\u7f16\\u53f7":"00648","\\u6570\\u91cf":"6.4998","\\u5355\\u4ef7":"48.0015000000000001","\\u91d1\\u989d":"312","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"24","\\u5546\\u54c1":"\\u6563\\u88dd\\u91d1\\u6854","\\u5546\\u54c1\\u7f16\\u53f7":"00652","\\u6570\\u91cf":"51.2846","\\u5355\\u4ef7":"5.9219","\\u91d1\\u989d":"303.69999999999999","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"25","\\u5546\\u54c1":"\\u9bc7\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00210","\\u6570\\u91cf":"7.185","\\u5355\\u4ef7":"40","\\u91d1\\u989d":"287.39999999999998","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"26","\\u5546\\u54c1":"\\u514d\\u6cbb\\u8c6c\\u8089","\\u5546\\u54c1\\u7f16\\u53f7":"00281","\\u6570\\u91cf":"4.9292","\\u5355\\u4ef7":"58.0013000000000005","\\u91d1\\u989d":"285.89999999999998","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"27","\\u5546\\u54c1":"\\u9752\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00084","\\u6570\\u91cf":"31.4448","\\u5355\\u4ef7":"9.0381","\\u91d1\\u989d":"284.19999999999999","\\u7b14\\u6570":"34","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"28","\\u5546\\u54c1":"\\u767d\\u8611\\u83c7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00061","\\u6570\\u91cf":"30.608","\\u5355\\u4ef7":"9.2002","\\u91d1\\u989d":"281.60000000000002","\\u7b14\\u6570":"25","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"29","\\u5546\\u54c1":"\\u4e0a\\u6d77\\u9752\\u82d7300g","\\u5546\\u54c1\\u7f16\\u53f7":"00019","\\u6570\\u91cf":"37.6985","\\u5355\\u4ef7":"7.422","\\u91d1\\u989d":"279.80000000000001","\\u7b14\\u6570":"37","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"30","\\u5546\\u54c1":"\\u6c99\\u5f8b\\u83dc-\\u5e36\\u91ac150g","\\u5546\\u54c1\\u7f16\\u53f7":"00075","\\u6570\\u91cf":"25.7013","\\u5355\\u4ef7":"10.4003","\\u91d1\\u989d":"267.30000000000001","\\u7b14\\u6570":"24","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"31","\\u5546\\u54c1":"\\u82a5\\u862d\\u82d7300g","\\u5546\\u54c1\\u7f16\\u53f7":"00014","\\u6570\\u91cf":"31.551","\\u5355\\u4ef7":"8.2628","\\u91d1\\u989d":"260.69999999999999","\\u7b14\\u6570":"28","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"32","\\u5546\\u54c1":"\\u5510\\u751f\\u83dc\\u82d7250g","\\u5546\\u54c1\\u7f16\\u53f7":"00303","\\u6570\\u91cf":"28.083500000000001","\\u5355\\u4ef7":"9.0267","\\u91d1\\u989d":"253.5","\\u7b14\\u6570":"36","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"33","\\u5546\\u54c1":"\\u8304\\u5b50(\\u7d2b)","\\u5546\\u54c1\\u7f16\\u53f7":"00029","\\u6570\\u91cf":"30.4197","\\u5355\\u4ef7":"8.317","\\u91d1\\u989d":"253","\\u7b14\\u6570":"48","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"34","\\u5546\\u54c1":"\\u871c\\u8702\\u6a59","\\u5546\\u54c1\\u7f16\\u53f7":"00399","\\u6570\\u91cf":"41.6675","\\u5355\\u4ef7":"5.9999","\\u91d1\\u989d":"250","\\u7b14\\u6570":"21","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"35","\\u5546\\u54c1":"\\u99ac\\u9234\\u85af","\\u5546\\u54c1\\u7f16\\u53f7":"00051","\\u6570\\u91cf":"42.2657","\\u5355\\u4ef7":"5.8676","\\u91d1\\u989d":"248","\\u7b14\\u6570":"37","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"36","\\u5546\\u54c1":"\\u828b\\u982d","\\u5546\\u54c1\\u7f16\\u53f7":"00052","\\u6570\\u91cf":"18.9127","\\u5355\\u4ef7":"12.6","\\u91d1\\u989d":"238.30000000000001","\\u7b14\\u6570":"20","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"37","\\u5546\\u54c1":"\\u767d\\u6d0b\\u8525","\\u5546\\u54c1\\u7f16\\u53f7":"00073","\\u6570\\u91cf":"47.28","\\u5355\\u4ef7":"5","\\u91d1\\u989d":"236.40000000000001","\\u7b14\\u6570":"49","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"38","\\u5546\\u54c1":"\\u9752\\u901a300g","\\u5546\\u54c1\\u7f16\\u53f7":"00017","\\u6570\\u91cf":"34.5896","\\u5355\\u4ef7":"6.5771","\\u91d1\\u989d":"227.5","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"39","\\u5546\\u54c1":"\\u756a\\u8304(\\u7c89)350g","\\u5546\\u54c1\\u7f16\\u53f7":"00030","\\u6570\\u91cf":"35","\\u5355\\u4ef7":"6.5","\\u91d1\\u989d":"227.5","\\u7b14\\u6570":"30","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"40","\\u5546\\u54c1":"\\u82ab\\u831c70g","\\u5546\\u54c1\\u7f16\\u53f7":"00307","\\u6570\\u91cf":"65","\\u5355\\u4ef7":"3.5","\\u91d1\\u989d":"227.5","\\u7b14\\u6570":"53","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"41","\\u5546\\u54c1":"\\u83e0\\u83dc\\u82d7300g","\\u5546\\u54c1\\u7f16\\u53f7":"00006","\\u6570\\u91cf":"21.429","\\u5355\\u4ef7":"10.4998","\\u91d1\\u989d":"225","\\u7b14\\u6570":"28","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"42","\\u5546\\u54c1":"\\u6c34\\u679c\\u6912250g","\\u5546\\u54c1\\u7f16\\u53f7":"00107","\\u6570\\u91cf":"17.307","\\u5355\\u4ef7":"13.00050000000000061","\\u91d1\\u989d":"225","\\u7b14\\u6570":"18","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"43","\\u5546\\u54c1":"\\u83e0\\u863f\\u871c","\\u5546\\u54c1\\u7f16\\u53f7":"00462","\\u6570\\u91cf":"16.085999999999999","\\u5355\\u4ef7":"13.6765","\\u91d1\\u989d":"220","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"44","\\u5546\\u54c1":"\\u6c34\\u679c\\u6cb9\\u74dc400g","\\u5546\\u54c1\\u7f16\\u53f7":"00266","\\u6570\\u91cf":"24.717","\\u5355\\u4ef7":"8.8441","\\u91d1\\u989d":"218.59999999999999","\\u7b14\\u6570":"26","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"45","\\u5546\\u54c1":"\\u6ab8\\u6aac","\\u5546\\u54c1\\u7f16\\u53f7":"00446","\\u6570\\u91cf":"86.40000000000001","\\u5355\\u4ef7":"2.5","\\u91d1\\u989d":"216","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"46","\\u5546\\u54c1":"\\u767d\\u8c46\\u89d2300g","\\u5546\\u54c1\\u7f16\\u53f7":"00036","\\u6570\\u91cf":"25.6084","\\u5355\\u4ef7":"8.2004","\\u91d1\\u989d":"210","\\u7b14\\u6570":"28","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"47","\\u5546\\u54c1":"\\u6728\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00193","\\u6570\\u91cf":"27.6684","\\u5355\\u4ef7":"7.5899","\\u91d1\\u989d":"210","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"48","\\u5546\\u54c1":"\\u4eac\\u5305","\\u5546\\u54c1\\u7f16\\u53f7":"00007","\\u6570\\u91cf":"49.4286","\\u5355\\u4ef7":"4.2","\\u91d1\\u989d":"207.59999999999999","\\u7b14\\u6570":"30","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"49","\\u5546\\u54c1":"\\u677f\\u6817\\u5357\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00086","\\u6570\\u91cf":"24.0581","\\u5355\\u4ef7":"8.6","\\u91d1\\u989d":"206.90000000000001","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"50","\\u5546\\u54c1":"\\u9716\\u8089","\\u5546\\u54c1\\u7f16\\u53f7":"00280","\\u6570\\u91cf":"3.0015000000000001","\\u5355\\u4ef7":"67.99930000000001","\\u91d1\\u989d":"204.099999999999994","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"51","\\u5546\\u54c1":"\\u65e5\\u672c\\u767d\\u86cb10\\u53ea","\\u5546\\u54c1\\u7f16\\u53f7":"00217","\\u6570\\u91cf":"8","\\u5355\\u4ef7":"25","\\u91d1\\u989d":"200","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"52","\\u5546\\u54c1":"\\u8056\\u5973\\u679c300g","\\u5546\\u54c1\\u7f16\\u53f7":"00392","\\u6570\\u91cf":"32.4588","\\u5355\\u4ef7":"6.1","\\u91d1\\u989d":"198","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"53","\\u5546\\u54c1":"\\u5927\\u725b\\u6cb9\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00486","\\u6570\\u91cf":"21.4445","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"193","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"54","\\u5546\\u54c1":"\\u756a\\u8304350g","\\u5546\\u54c1\\u7f16\\u53f7":"00089","\\u6570\\u91cf":"29.1655","\\u5355\\u4ef7":"6.6003","\\u91d1\\u989d":"192.5","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"55","\\u5546\\u54c1":"\\u9e7d\\u6c34\\u82b1\\u751f","\\u5546\\u54c1\\u7f16\\u53f7":"00470","\\u6570\\u91cf":"21","\\u5355\\u4ef7":"9.1429","\\u91d1\\u989d":"192","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"56","\\u5546\\u54c1":"\\u83dc\\u5fc3\\u82d7300g","\\u5546\\u54c1\\u7f16\\u53f7":"00022","\\u6570\\u91cf":"24.7625","\\u5355\\u4ef7":"7.6729","\\u91d1\\u989d":"190","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"57","\\u5546\\u54c1":"\\u6c99\\u947d\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00668","\\u6570\\u91cf":"4.4905","\\u5355\\u4ef7":"41.9998","\\u91d1\\u989d":"188.59999999999999","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"58","\\u5546\\u54c1":"\\u4e32\\u8304198g","\\u5546\\u54c1\\u7f16\\u53f7":"00309","\\u6570\\u91cf":"10.8097","\\u5355\\u4ef7":"17.2993","\\u91d1\\u989d":"187","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"59","\\u5546\\u54c1":"\\u725b\\u5976\\u8549","\\u5546\\u54c1\\u7f16\\u53f7":"00468","\\u6570\\u91cf":"20.3445","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"183.099999999999994","\\u7b14\\u6570":"13","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"60","\\u5546\\u54c1":"\\u8c6c\\u6f64","\\u5546\\u54c1\\u7f16\\u53f7":"00268","\\u6570\\u91cf":"5.1258","\\u5355\\u4ef7":"34.9994","\\u91d1\\u989d":"179.40000000000001","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"61","\\u5546\\u54c1":"\\u6587\\u660c\\u96de1.1-1.3KG","\\u5546\\u54c1\\u7f16\\u53f7":"00319","\\u6570\\u91cf":"2.4722","\\u5355\\u4ef7":"72.00060000000000571","\\u91d1\\u989d":"178","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"62","\\u5546\\u54c1":"\\u8fa3\\u6912(\\u676d\\u6912)250g","\\u5546\\u54c1\\u7f16\\u53f7":"00111","\\u6570\\u91cf":"23","\\u5355\\u4ef7":"7.5","\\u91d1\\u989d":"172.5","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"63","\\u5546\\u54c1":"\\u4e0a\\u6d77\\u9752300g","\\u5546\\u54c1\\u7f16\\u53f7":"00018","\\u6570\\u91cf":"24.6814","\\u5355\\u4ef7":"6.9526","\\u91d1\\u989d":"171.59999999999999","\\u7b14\\u6570":"33","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"64","\\u5546\\u54c1":"\\u5927\\u982d\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00289","\\u6570\\u91cf":"4.27","\\u5355\\u4ef7":"40","\\u91d1\\u989d":"170.80000000000001","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"65","\\u5546\\u54c1":"\\u7389\\u7c73(\\u751c)","\\u5546\\u54c1\\u7f16\\u53f7":"00033","\\u6570\\u91cf":"18.899","\\u5355\\u4ef7":"8.8999","\\u91d1\\u989d":"168.19999999999999","\\u7b14\\u6570":"26","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"66","\\u5546\\u54c1":"\\u5c0f\\u571f\\u8c46400g","\\u5546\\u54c1\\u7f16\\u53f7":"00096","\\u6570\\u91cf":"40.9016","\\u5355\\u4ef7":"4.1001","\\u91d1\\u989d":"167.69999999999999","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"67","\\u5546\\u54c1":"\\u4e09\\u8272\\u5f69\\u6912550g","\\u5546\\u54c1\\u7f16\\u53f7":"00112","\\u6570\\u91cf":"9.8736","\\u5355\\u4ef7":"16.5998","\\u91d1\\u989d":"163.90000000000001","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"68","\\u5546\\u54c1":"\\u8606\\u7b4d200g","\\u5546\\u54c1\\u7f16\\u53f7":"00050","\\u6570\\u91cf":"6.88","\\u5355\\u4ef7":"23.2558","\\u91d1\\u989d":"160","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"69","\\u5546\\u54c1":"\\u9ec4\\u79cb\\u8475200g","\\u5546\\u54c1\\u7f16\\u53f7":"00088","\\u6570\\u91cf":"20.8198","\\u5355\\u4ef7":"7.3968","\\u91d1\\u989d":"154","\\u7b14\\u6570":"20","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"70","\\u5546\\u54c1":"\\u767e\\u798f\\u84b8\\u716e\\u8c46\\u8150350ml\\/\\u76d2","\\u5546\\u54c1\\u7f16\\u53f7":"00189","\\u6570\\u91cf":"22","\\u5355\\u4ef7":"7","\\u91d1\\u989d":"154","\\u7b14\\u6570":"19","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"71","\\u5546\\u54c1":"\\u6cb9\\u9ea5\\u83dc\\u82d7250g","\\u5546\\u54c1\\u7f16\\u53f7":"00304","\\u6570\\u91cf":"15.9159","\\u5355\\u4ef7":"9.4999","\\u91d1\\u989d":"151.19999999999999","\\u7b14\\u6570":"20","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"72","\\u5546\\u54c1":"\\u5730\\u74dc\\u8449300g","\\u5546\\u54c1\\u7f16\\u53f7":"00077","\\u6570\\u91cf":"25.1694","\\u5355\\u4ef7":"5.9","\\u91d1\\u989d":"148.5","\\u7b14\\u6570":"24","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"73","\\u5546\\u54c1":"\\u8089\\u773c\\uff08\\u8089\\u6252\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00273","\\u6570\\u91cf":"2.8242","\\u5355\\u4ef7":"52.014699999999998","\\u91d1\\u989d":"146.90000000000001","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"74","\\u5546\\u54c1":"\\u5927\\u7d05\\u6912250g","\\u5546\\u54c1\\u7f16\\u53f7":"00109","\\u6570\\u91cf":"15.2099","\\u5355\\u4ef7":"9.5004","\\u91d1\\u989d":"144.5","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"75","\\u5546\\u54c1":"\\u751c\\u8c46300g","\\u5546\\u54c1\\u7f16\\u53f7":"00039","\\u6570\\u91cf":"11.4282","\\u5355\\u4ef7":"12.6004","\\u91d1\\u989d":"144","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"76","\\u5546\\u54c1":"\\u7af9\\u7d72\\u96de\\uff08\\u5c0f \\uff090.9-1.0KG","\\u5546\\u54c1\\u7f16\\u53f7":"00316","\\u6570\\u91cf":"3.7896","\\u5355\\u4ef7":"37.9987","\\u91d1\\u989d":"144","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"77","\\u5546\\u54c1":"\\u83e0\\u863f","\\u5546\\u54c1\\u7f16\\u53f7":"00439","\\u6570\\u91cf":"12","\\u5355\\u4ef7":"12","\\u91d1\\u989d":"144","\\u7b14\\u6570":"12","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"78","\\u5546\\u54c1":"\\u73e0\\u8525150g","\\u5546\\u54c1\\u7f16\\u53f7":"00067","\\u6570\\u91cf":"34.2914","\\u5355\\u4ef7":"4.1002","\\u91d1\\u989d":"140.59999999999999","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"79","\\u5546\\u54c1":"\\u5a03\\u5a03\\u83dc\\uff08\\u4e09\\u500b\\u88c5\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00001","\\u6570\\u91cf":"16.868","\\u5355\\u4ef7":"8.2997","\\u91d1\\u989d":"140","\\u7b14\\u6570":"20","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"80","\\u5546\\u54c1":"\\u51ac\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00023","\\u6570\\u91cf":"31.7046","\\u5355\\u4ef7":"4.4","\\u91d1\\u989d":"139.5","\\u7b14\\u6570":"22","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"81","\\u5546\\u54c1":"\\u661f\\u9c78","\\u5546\\u54c1\\u7f16\\u53f7":"00226","\\u6570\\u91cf":"4.6434","\\u5355\\u4ef7":"29.9996","\\u91d1\\u989d":"139.30000000000001","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"82","\\u5546\\u54c1":"\\u6e56\\u5357\\u6912250g","\\u5546\\u54c1\\u7f16\\u53f7":"00065","\\u6570\\u91cf":"23.7075","\\u5355\\u4ef7":"5.7999","\\u91d1\\u989d":"137.5","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"83","\\u5546\\u54c1":"\\u8c46\\u85141\\u4efd","\\u5546\\u54c1\\u7f16\\u53f7":"00194","\\u6570\\u91cf":"16","\\u5355\\u4ef7":"8.5","\\u91d1\\u989d":"136","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"84","\\u5546\\u54c1":"\\u6538\\u7e23\\u9999\\u5e72200g\\/\\u888b","\\u5546\\u54c1\\u7f16\\u53f7":"00342","\\u6570\\u91cf":"20","\\u5355\\u4ef7":"6.8","\\u91d1\\u989d":"136","\\u7b14\\u6570":"20","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"85","\\u5546\\u54c1":"\\u6787\\u6777","\\u5546\\u54c1\\u7f16\\u53f7":"00395","\\u6570\\u91cf":"6.644","\\u5355\\u4ef7":"20.3191","\\u91d1\\u989d":"135","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"86","\\u5546\\u54c1":"\\u8377\\u862d\\u8c46200g","\\u5546\\u54c1\\u7f16\\u53f7":"00037","\\u6570\\u91cf":"14.9435","\\u5355\\u4ef7":"8.9002","\\u91d1\\u989d":"133","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"87","\\u5546\\u54c1":"\\u9bae\\u6dee\\u5c71","\\u5546\\u54c1\\u7f16\\u53f7":"00095","\\u6570\\u91cf":"9.5355","\\u5355\\u4ef7":"13.9374","\\u91d1\\u989d":"132.90000000000001","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"88","\\u5546\\u54c1":"\\u83dc\\u5fc3300g","\\u5546\\u54c1\\u7f16\\u53f7":"00021","\\u6570\\u91cf":"15.8841","\\u5355\\u4ef7":"8.1843","\\u91d1\\u989d":"130","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"89","\\u5546\\u54c1":"\\u677f\\u6817\\u8089200g","\\u5546\\u54c1\\u7f16\\u53f7":"00038","\\u6570\\u91cf":"10.6392","\\u5355\\u4ef7":"12.2002","\\u91d1\\u989d":"129.80000000000001","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"90","\\u5546\\u54c1":"\\u798f\\u5efa\\u82b1(\\u6563\\u82b1\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00386","\\u6570\\u91cf":"11.7204","\\u5355\\u4ef7":"10.887","\\u91d1\\u989d":"127.59999999999999","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"91","\\u5546\\u54c1":"\\u7f85\\u975e\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00292","\\u6570\\u91cf":"5.084","\\u5355\\u4ef7":"25","\\u91d1\\u989d":"127.099999999999994","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"92","\\u5546\\u54c1":"\\u6307\\u5929\\u6912100g","\\u5546\\u54c1\\u7f16\\u53f7":"00108","\\u6570\\u91cf":"18.071100000000001","\\u5355\\u4ef7":"7.0001","\\u91d1\\u989d":"126.5","\\u7b14\\u6570":"22","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"93","\\u5546\\u54c1":"\\u91d1\\u91dd\\u83c7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00100","\\u6570\\u91cf":"36.8808","\\u5355\\u4ef7":"3.4001","\\u91d1\\u989d":"125.40000000000001","\\u7b14\\u6570":"24","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"94","\\u5546\\u54c1":"\\u5357\\u74dc(\\u8c9d\\u8c9d\\u5357\\u74dc)","\\u5546\\u54c1\\u7f16\\u53f7":"00085","\\u6570\\u91cf":"15.8206","\\u5355\\u4ef7":"7.8","\\u91d1\\u989d":"123.40000000000001","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"95","\\u5546\\u54c1":"\\u897f\\u82b9","\\u5546\\u54c1\\u7f16\\u53f7":"00069","\\u6570\\u91cf":"15.7012","\\u5355\\u4ef7":"7.7","\\u91d1\\u989d":"120.90000000000001","\\u7b14\\u6570":"30","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"96","\\u5546\\u54c1":"\\u6885\\u982d\\u7626\\u8089","\\u5546\\u54c1\\u7f16\\u53f7":"00283","\\u6570\\u91cf":"1.1664","\\u5355\\u4ef7":"103.4808","\\u91d1\\u989d":"120.7","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"97","\\u5546\\u54c1":"\\u8fa3\\u6912(\\u87ba\\u7d72\\u6912)250g","\\u5546\\u54c1\\u7f16\\u53f7":"00064","\\u6570\\u91cf":"23.5296","\\u5355\\u4ef7":"5.1","\\u91d1\\u989d":"120","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"98","\\u5546\\u54c1":"\\u7da0\\u8c46\\u82bd300g","\\u5546\\u54c1\\u7f16\\u53f7":"00055","\\u6570\\u91cf":"29.0258","\\u5355\\u4ef7":"4.0998","\\u91d1\\u989d":"119","\\u7b14\\u6570":"31","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"99","\\u5546\\u54c1":"\\u5b78\\u9b25\\u767d\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00390","\\u6570\\u91cf":"12.9298","\\u5355\\u4ef7":"9.1649","\\u91d1\\u989d":"118.5","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"100","\\u5546\\u54c1":"\\u767d\\u5009\\u9b5a","\\u5546\\u54c1\\u7f16\\u53f7":"00667","\\u6570\\u91cf":"2.4015","\\u5355\\u4ef7":"49.1776","\\u91d1\\u989d":"118.099999999999994","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"101","\\u5546\\u54c1":"\\u767d\\u863f\\u8514","\\u5546\\u54c1\\u7f16\\u53f7":"00045","\\u6570\\u91cf":"26.4864","\\u5355\\u4ef7":"4.3607","\\u91d1\\u989d":"115.5","\\u7b14\\u6570":"23","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"102","\\u5546\\u54c1":"\\u5927\\u8525","\\u5546\\u54c1\\u7f16\\u53f7":"00068","\\u6570\\u91cf":"11.6066","\\u5355\\u4ef7":"9.8995","\\u91d1\\u989d":"114.90000000000001","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"103","\\u5546\\u54c1":"\\u6bdb\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00083","\\u6570\\u91cf":"13.0518","\\u5355\\u4ef7":"8.6348","\\u91d1\\u989d":"112.7","\\u7b14\\u6570":"16","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"104","\\u5546\\u54c1":"\\u6bdb\\u8c46500g","\\u5546\\u54c1\\u7f16\\u53f7":"00092","\\u6570\\u91cf":"9.9558","\\u5355\\u4ef7":"11.2999","\\u91d1\\u989d":"112.5","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"105","\\u5546\\u54c1":"\\u5c0f\\u65fa\\u83dc","\\u5546\\u54c1\\u7f16\\u53f7":"00004","\\u6570\\u91cf":"22.46","\\u5355\\u4ef7":"5","\\u91d1\\u989d":"112.3","\\u7b14\\u6570":"17","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"106","\\u5546\\u54c1":"\\u6728\\u8033200g","\\u5546\\u54c1\\u7f16\\u53f7":"00062","\\u6570\\u91cf":"27.8536","\\u5355\\u4ef7":"3.9205","\\u91d1\\u989d":"109.2","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"107","\\u5546\\u54c1":"\\u56db\\u5b63\\u8c46450g","\\u5546\\u54c1\\u7f16\\u53f7":"00034","\\u6570\\u91cf":"9.813","\\u5355\\u4ef7":"10.7001","\\u91d1\\u989d":"105","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"108","\\u5546\\u54c1":"\\u51ac\\u83c7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00101","\\u6570\\u91cf":"13.2916","\\u5355\\u4ef7":"7.8997","\\u91d1\\u989d":"105","\\u7b14\\u6570":"13","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"109","\\u5546\\u54c1":"\\u99ac\\u8e44500g","\\u5546\\u54c1\\u7f16\\u53f7":"00041","\\u6570\\u91cf":"9.8582","\\u5355\\u4ef7":"10.6003","\\u91d1\\u989d":"104.5","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"110","\\u5546\\u54c1":"\\u7d05\\u83dc\\u982d","\\u5546\\u54c1\\u7f16\\u53f7":"00048","\\u6570\\u91cf":"14.6901","\\u5355\\u4ef7":"7.1","\\u91d1\\u989d":"104.3","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"111","\\u5546\\u54c1":"\\u4e94\\u82b1\\u8169","\\u5546\\u54c1\\u7f16\\u53f7":"00284","\\u6570\\u91cf":"1.7162","\\u5355\\u4ef7":"60.4825","\\u91d1\\u989d":"103.8","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"112","\\u5546\\u54c1":"\\u7c89\\u845b","\\u5546\\u54c1\\u7f16\\u53f7":"00060","\\u6570\\u91cf":"7.5037","\\u5355\\u4ef7":"13.6999","\\u91d1\\u989d":"102.8","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"113","\\u5546\\u54c1":"\\u6930\\u83dc\\u82b1(\\u767d\\u82b1\\u83dc)","\\u5546\\u54c1\\u7f16\\u53f7":"00011","\\u6570\\u91cf":"9.9369","\\u5355\\u4ef7":"10.3352","\\u91d1\\u989d":"102.7","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"114","\\u5546\\u54c1":"\\u80e1\\u863f\\u8514(\\u6ce5\\u7d05\\u863f\\u8514)","\\u5546\\u54c1\\u7f16\\u53f7":"00046","\\u6570\\u91cf":"17.1379","\\u5355\\u4ef7":"5.8","\\u91d1\\u989d":"99.40000000000001","\\u7b14\\u6570":"27","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"115","\\u5546\\u54c1":"\\u7cd6\\u5fc3\\u871c\\u85af","\\u5546\\u54c1\\u7f16\\u53f7":"00093","\\u6570\\u91cf":"10.9327","\\u5355\\u4ef7":"8.8999","\\u91d1\\u989d":"97.3","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"116","\\u5546\\u54c1":"\\u98db\\u6392","\\u5546\\u54c1\\u7f16\\u53f7":"00279","\\u6570\\u91cf":"0.9898","\\u5355\\u4ef7":"97.9996","\\u91d1\\u989d":"97","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"117","\\u5546\\u54c1":"\\u767e\\u798f\\u786c\\u8c46\\u8150340g\\/\\u76d2","\\u5546\\u54c1\\u7f16\\u53f7":"00188","\\u6570\\u91cf":"12","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"96","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"118","\\u5546\\u54c1":"\\u5c0f\\u5496\\u5561\\u83c7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00118","\\u6570\\u91cf":"12","\\u5355\\u4ef7":"7.9","\\u91d1\\u989d":"94.8","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"119","\\u5546\\u54c1":"\\u6cb9\\u9ea5\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00020","\\u6570\\u91cf":"14.864","\\u5355\\u4ef7":"6.2971","\\u91d1\\u989d":"93.59999999999999","\\u7b14\\u6570":"18","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"120","\\u5546\\u54c1":"\\u79c0\\u73cd\\u83c7150g","\\u5546\\u54c1\\u7f16\\u53f7":"00322","\\u6570\\u91cf":"10.6416","\\u5355\\u4ef7":"8.7957","\\u91d1\\u989d":"93.59999999999999","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"121","\\u5546\\u54c1":"\\u6bdb\\u8c46\\u4ec1200g","\\u5546\\u54c1\\u7f16\\u53f7":"00372","\\u6570\\u91cf":"11.2776","\\u5355\\u4ef7":"8.2996","\\u91d1\\u989d":"93.59999999999999","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"122","\\u5546\\u54c1":"\\u4e0a\\u6d77\\u6c34\\u9903\\u76ae\\uff08\\u767d\\u5713\\u76ae\\uff09350g","\\u5546\\u54c1\\u7f16\\u53f7":"00206","\\u6570\\u91cf":"11","\\u5355\\u4ef7":"8.5","\\u91d1\\u989d":"93.5","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"123","\\u5546\\u54c1":"\\u9577\\u6c34\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00031","\\u6570\\u91cf":"10.8353","\\u5355\\u4ef7":"8.5","\\u91d1\\u989d":"92.099999999999994","\\u7b14\\u6570":"13","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"124","\\u5546\\u54c1":"\\u8c6c\\u5c55","\\u5546\\u54c1\\u7f16\\u53f7":"00263","\\u6570\\u91cf":"1.0261","\\u5355\\u4ef7":"88.0031000000000034","\\u91d1\\u989d":"90.3","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"125","\\u5546\\u54c1":"\\u96de\\u6bdb\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00327","\\u6570\\u91cf":"11.8924","\\u5355\\u4ef7":"7.5679","\\u91d1\\u989d":"90","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"126","\\u5546\\u54c1":"\\u84ee\\u85d5","\\u5546\\u54c1\\u7f16\\u53f7":"00094","\\u6570\\u91cf":"8.4095","\\u5355\\u4ef7":"10.5","\\u91d1\\u989d":"88.3","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"127","\\u5546\\u54c1":"\\u9bae\\u9435\\u68cd\\u6dee\\u5c71","\\u5546\\u54c1\\u7f16\\u53f7":"00049","\\u6570\\u91cf":"6.7582","\\u5355\\u4ef7":"13.0063999999999993","\\u91d1\\u989d":"87.90000000000001","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"128","\\u5546\\u54c1":"\\u82b9\\u83dc150g","\\u5546\\u54c1\\u7f16\\u53f7":"00119","\\u6570\\u91cf":"23.334","\\u5355\\u4ef7":"3.5999","\\u91d1\\u989d":"84","\\u7b14\\u6570":"23","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"129","\\u5546\\u54c1":"\\u8c6c\\u809a\\uff08\\u500b\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00251","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"42","\\u91d1\\u989d":"84","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"130","\\u5546\\u54c1":"\\u9d6a\\u9d89\\u86cb","\\u5546\\u54c1\\u7f16\\u53f7":"00564","\\u6570\\u91cf":"7","\\u5355\\u4ef7":"12","\\u91d1\\u989d":"84","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"131","\\u5546\\u54c1":"\\u6d0b\\u8525(\\u7d05)","\\u5546\\u54c1\\u7f16\\u53f7":"00074","\\u6570\\u91cf":"14.2759","\\u5355\\u4ef7":"5.8","\\u91d1\\u989d":"82.8","\\u7b14\\u6570":"15","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"132","\\u5546\\u54c1":"\\u6392\\u9aa8\\u982d","\\u5546\\u54c1\\u7f16\\u53f7":"00260","\\u6570\\u91cf":"1.0577","\\u5355\\u4ef7":"77.99939999999999","\\u91d1\\u989d":"82.5","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"133","\\u5546\\u54c1":"\\u8435\\u7b4d","\\u5546\\u54c1\\u7f16\\u53f7":"00325","\\u6570\\u91cf":"10.9409","\\u5355\\u4ef7":"7.5131","\\u91d1\\u989d":"82.2","\\u7b14\\u6570":"14","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"134","\\u5546\\u54c1":"\\u5bcc\\u58eb\\u82f9\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00427","\\u6570\\u91cf":"13.3332","\\u5355\\u4ef7":"6.0001","\\u91d1\\u989d":"80","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"135","\\u5546\\u54c1":"\\u91d1\\u5947\\u7570\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00556","\\u6570\\u91cf":"6.5556","\\u5355\\u4ef7":"12.2033","\\u91d1\\u989d":"80","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"136","\\u5546\\u54c1":"\\u97ed\\u738b150g","\\u5546\\u54c1\\u7f16\\u53f7":"00070","\\u6570\\u91cf":"12.0243","\\u5355\\u4ef7":"6.4869","\\u91d1\\u989d":"78","\\u7b14\\u6570":"11","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"137","\\u5546\\u54c1":"\\u767e\\u5408\\u56db\\u982d","\\u5546\\u54c1\\u7f16\\u53f7":"00362","\\u6570\\u91cf":"6","\\u5355\\u4ef7":"12.6","\\u91d1\\u989d":"75.59999999999999","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"138","\\u5546\\u54c1":"\\u7fbd\\u8863\\u7518\\u85cd150g","\\u5546\\u54c1\\u7f16\\u53f7":"00009","\\u6570\\u91cf":"13.6365","\\u5355\\u4ef7":"5.4999","\\u91d1\\u989d":"75","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"139","\\u5546\\u54c1":"\\u833c\\u84bf300g","\\u5546\\u54c1\\u7f16\\u53f7":"00401","\\u6570\\u91cf":"8.074","\\u5355\\u4ef7":"9.2891","\\u91d1\\u989d":"75","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"140","\\u5546\\u54c1":"\\u897f\\u65bd","\\u5546\\u54c1\\u7f16\\u53f7":"00287","\\u6570\\u91cf":"1.208","\\u5355\\u4ef7":"62.003300000000003","\\u91d1\\u989d":"74.90000000000001","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"141","\\u5546\\u54c1":"\\u5927\\u767d\\u83dc","\\u5546\\u54c1\\u7f16\\u53f7":"00003","\\u6570\\u91cf":"15.4682","\\u5355\\u4ef7":"4.7","\\u91d1\\u989d":"72.7","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"142","\\u5546\\u54c1":"\\u4f5b\\u624b\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00040","\\u6570\\u91cf":"9.0375","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"72.3","\\u7b14\\u6570":"12","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"143","\\u5546\\u54c1":"\\u676d\\u767d\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00076","\\u6570\\u91cf":"15","\\u5355\\u4ef7":"4.8","\\u91d1\\u989d":"72","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"144","\\u5546\\u54c1":"\\u9e79\\u86cb4\\u53ea","\\u5546\\u54c1\\u7f16\\u53f7":"00147","\\u6570\\u91cf":"8","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"72","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"145","\\u5546\\u54c1":"\\u8c4c\\u8c46\\u4ec1200g","\\u5546\\u54c1\\u7f16\\u53f7":"00373","\\u6570\\u91cf":"8.4582","\\u5355\\u4ef7":"8.2996","\\u91d1\\u989d":"70.2","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"146","\\u5546\\u54c1":"\\u771f\\u7a7a\\u6dee\\u5c71\\u8089300g","\\u5546\\u54c1\\u7f16\\u53f7":"00312","\\u6570\\u91cf":"7.312","\\u5355\\u4ef7":"9.2998","\\u91d1\\u989d":"68","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"147","\\u5546\\u54c1":"\\u6538\\u7e23\\u767d\\u5e72200g\\/\\u888b","\\u5546\\u54c1\\u7f16\\u53f7":"00341","\\u6570\\u91cf":"10","\\u5355\\u4ef7":"6.7","\\u91d1\\u989d":"67","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"148","\\u5546\\u54c1":"\\u7d2b\\u6930\\u83dc","\\u5546\\u54c1\\u7f16\\u53f7":"00008","\\u6570\\u91cf":"8.6316","\\u5355\\u4ef7":"7.6","\\u91d1\\u989d":"65.59999999999999","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"149","\\u5546\\u54c1":"\\u8c6c\\u5c55\\u9aa8","\\u5546\\u54c1\\u7f16\\u53f7":"00246","\\u6570\\u91cf":"1.3461","\\u5355\\u4ef7":"48.3619","\\u91d1\\u989d":"65.099999999999994","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"150","\\u5546\\u54c1":"\\u7687\\u5e1d\\u83dc\\u82d7300g","\\u5546\\u54c1\\u7f16\\u53f7":"00324","\\u6570\\u91cf":"5.6414","\\u5355\\u4ef7":"11.522","\\u91d1\\u989d":"65","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"151","\\u5546\\u54c1":"\\u828b\\u4ed4300g","\\u5546\\u54c1\\u7f16\\u53f7":"00097","\\u6570\\u91cf":"10.6392","\\u5355\\u4ef7":"6.1001","\\u91d1\\u989d":"64.90000000000001","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"152","\\u5546\\u54c1":"\\u7389\\u7c73\\u7b4d200g","\\u5546\\u54c1\\u7f16\\u53f7":"00032","\\u6570\\u91cf":"7","\\u5355\\u4ef7":"9.2","\\u91d1\\u989d":"64.40000000000001","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"153","\\u5546\\u54c1":"\\u7d2b\\u85af500g","\\u5546\\u54c1\\u7f16\\u53f7":"00387","\\u6570\\u91cf":"7.1008","\\u5355\\u4ef7":"8.9004","\\u91d1\\u989d":"63.2","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"154","\\u5546\\u54c1":"\\u4eba\\u53c3\\u767d\\u85af","\\u5546\\u54c1\\u7f16\\u53f7":"00497","\\u6570\\u91cf":"8","\\u5355\\u4ef7":"7.9","\\u91d1\\u989d":"63.2","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"155","\\u5546\\u54c1":"\\u810a\\u9aa8","\\u5546\\u54c1\\u7f16\\u53f7":"00264","\\u6570\\u91cf":"0.9742","\\u5355\\u4ef7":"61.9996","\\u91d1\\u989d":"60.4","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"156","\\u5546\\u54c1":"\\u9bae\\u8611\\u83c7(\\u5496\\u5561\\u83c7)200g","\\u5546\\u54c1\\u7f16\\u53f7":"00105","\\u6570\\u91cf":"5.769","\\u5355\\u4ef7":"10.4004","\\u91d1\\u989d":"60","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"157","\\u5546\\u54c1":"\\u6c99\\u7cd6\\u6854","\\u5546\\u54c1\\u7f16\\u53f7":"00369","\\u6570\\u91cf":"10.00019999999999953","\\u5355\\u4ef7":"5.9999","\\u91d1\\u989d":"60","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"158","\\u5546\\u54c1":"\\u767e\\u9999\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00443","\\u6570\\u91cf":"24","\\u5355\\u4ef7":"2.5","\\u91d1\\u989d":"60","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"159","\\u5546\\u54c1":"\\u6cb9\\u67d1","\\u5546\\u54c1\\u7f16\\u53f7":"00494","\\u6570\\u91cf":"4.00020000000000042","\\u5355\\u4ef7":"14.9993","\\u91d1\\u989d":"60","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"160","\\u5546\\u54c1":"\\u5c0f\\u9752\\u74dc400g","\\u5546\\u54c1\\u7f16\\u53f7":"00024","\\u6570\\u91cf":"4.7502","\\u5355\\u4ef7":"11.9995","\\u91d1\\u989d":"57","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"161","\\u5546\\u54c1":"\\u6cb3\\u7c89\\uff08\\u7092\\u7c89\\uff09350g","\\u5546\\u54c1\\u7f16\\u53f7":"00212","\\u6570\\u91cf":"7","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"56","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"162","\\u5546\\u54c1":"\\u897f\\u846b\\u8606\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00028","\\u6570\\u91cf":"8.8413","\\u5355\\u4ef7":"6.3","\\u91d1\\u989d":"55.7","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"163","\\u5546\\u54c1":"\\u5357\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00026","\\u6570\\u91cf":"12.3864","\\u5355\\u4ef7":"4.4","\\u91d1\\u989d":"54.5","\\u7b14\\u6570":"12","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"164","\\u5546\\u54c1":"\\u674f\\u9b91\\u83c7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00102","\\u6570\\u91cf":"9","\\u5355\\u4ef7":"5.8","\\u91d1\\u989d":"52.2","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"165","\\u5546\\u54c1":"\\u7cef\\u7c9f\\u7c73","\\u5546\\u54c1\\u7f16\\u53f7":"00091","\\u6570\\u91cf":"5.296","\\u5355\\u4ef7":"9.7998","\\u91d1\\u989d":"51.9","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"166","\\u5546\\u54c1":"\\u4e0a\\u6d77\\u9eb5350g","\\u5546\\u54c1\\u7f16\\u53f7":"00148","\\u6570\\u91cf":"6","\\u5355\\u4ef7":"8.5","\\u91d1\\u989d":"51","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"167","\\u5546\\u54c1":"\\u5305\\u9b5a\\u9aa8","\\u5546\\u54c1\\u7f16\\u53f7":"00254","\\u6570\\u91cf":"1.8036","\\u5355\\u4ef7":"27.9996","\\u91d1\\u989d":"50.5","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"168","\\u5546\\u54c1":"\\u897f\\u6d0b\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00323","\\u6570\\u91cf":"5.682","\\u5355\\u4ef7":"8.7997","\\u91d1\\u989d":"50","\\u7b14\\u6570":"7","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"169","\\u5546\\u54c1":"\\u82b1\\u751f(\\u9bae)300g","\\u5546\\u54c1\\u7f16\\u53f7":"00321","\\u6570\\u91cf":"6","\\u5355\\u4ef7":"8.3","\\u91d1\\u989d":"49.8","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"170","\\u5546\\u54c1":"\\u91d1\\u88dd\\u725b\\u8089\\u4e38250g\\/\\u5305","\\u5546\\u54c1\\u7f16\\u53f7":"00296","\\u6570\\u91cf":"3","\\u5355\\u4ef7":"16.5","\\u91d1\\u989d":"49.5","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"171","\\u5546\\u54c1":"\\u4e00\\u9ede\\u7d05\\u756a\\u85af","\\u5546\\u54c1\\u7f16\\u53f7":"00656","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"9.9","\\u91d1\\u989d":"49.5","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"172","\\u5546\\u54c1":"\\u82a5\\u862d300g","\\u5546\\u54c1\\u7f16\\u53f7":"00015","\\u6570\\u91cf":"6.2022","\\u5355\\u4ef7":"7.6747","\\u91d1\\u989d":"47.6","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"173","\\u5546\\u54c1":"\\u9752\\u5c16\\u6912250g","\\u5546\\u54c1\\u7f16\\u53f7":"00066","\\u6570\\u91cf":"9.36","\\u5355\\u4ef7":"5","\\u91d1\\u989d":"46.8","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"174","\\u5546\\u54c1":"\\u97ed\\u83dc150g","\\u5546\\u54c1\\u7f16\\u53f7":"00071","\\u6570\\u91cf":"11.4706","\\u5355\\u4ef7":"4.0277","\\u91d1\\u989d":"46.2","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"175","\\u5546\\u54c1":"\\u9999\\u6a01150g","\\u5546\\u54c1\\u7f16\\u53f7":"00155","\\u6570\\u91cf":"1.8096","\\u5355\\u4ef7":"25.1989","\\u91d1\\u989d":"45.6","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"176","\\u5546\\u54c1":"\\u96f2\\u541e\\u9eb5\\uff08\\u5e7c\\uff09350g","\\u5546\\u54c1\\u7f16\\u53f7":"00208","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"45","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"177","\\u5546\\u54c1":"\\u62db\\u724c\\u53c9\\u71d2\\u5305 120g*4\\u500b","\\u5546\\u54c1\\u7f16\\u53f7":"00537","\\u6570\\u91cf":"3","\\u5355\\u4ef7":"15","\\u91d1\\u989d":"45","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"178","\\u5546\\u54c1":"\\u7af9\\u8517","\\u5546\\u54c1\\u7f16\\u53f7":"00058","\\u6570\\u91cf":"6.5441","\\u5355\\u4ef7":"6.8","\\u91d1\\u989d":"44.5","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"179","\\u5546\\u54c1":"\\u849c\\u5fc3300g","\\u5546\\u54c1\\u7f16\\u53f7":"00072","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"8.9","\\u91d1\\u989d":"44.5","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"180","\\u5546\\u54c1":"\\u9999\\u7d20\\u96de200g\\/\\u888b","\\u5546\\u54c1\\u7f16\\u53f7":"00343","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"8.6","\\u91d1\\u989d":"43","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"181","\\u5546\\u54c1":"\\u84b2\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00027","\\u6570\\u91cf":"7.421","\\u5355\\u4ef7":"5.7","\\u91d1\\u989d":"42.3","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"182","\\u5546\\u54c1":"\\u9752\\u863f\\u8514","\\u5546\\u54c1\\u7f16\\u53f7":"00043","\\u6570\\u91cf":"7.6483","\\u5355\\u4ef7":"5.3999","\\u91d1\\u989d":"41.3","\\u7b14\\u6570":"10","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"183","\\u5546\\u54c1":"\\u6c34\\u679c\\u863f\\u8514","\\u5546\\u54c1\\u7f16\\u53f7":"00044","\\u6570\\u91cf":"4.8929","\\u5355\\u4ef7":"8.3999","\\u91d1\\u989d":"41.1","\\u7b14\\u6570":"8","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"184","\\u5546\\u54c1":"\\u9752\\u6728\\u74dc","\\u5546\\u54c1\\u7f16\\u53f7":"00113","\\u6570\\u91cf":"7.7548","\\u5355\\u4ef7":"5.2999","\\u91d1\\u989d":"41.1","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"185","\\u5546\\u54c1":"\\u9ec3\\u76ae\\u6912250g","\\u5546\\u54c1\\u7f16\\u53f7":"00063","\\u6570\\u91cf":"7.2746","\\u5355\\u4ef7":"5.5811","\\u91d1\\u989d":"40.6","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"186","\\u5546\\u54c1":"\\u6c99\\u845b","\\u5546\\u54c1\\u7f16\\u53f7":"00057","\\u6570\\u91cf":"5.1948","\\u5355\\u4ef7":"7.7","\\u91d1\\u989d":"40","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"187","\\u5546\\u54c1":"\\u679c\\u51cd\\u6a59","\\u5546\\u54c1\\u7f16\\u53f7":"00131","\\u6570\\u91cf":"4","\\u5355\\u4ef7":"10","\\u91d1\\u989d":"40","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"188","\\u5546\\u54c1":"\\u6cb9\\u9eb5350g","\\u5546\\u54c1\\u7f16\\u53f7":"00204","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"40","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"189","\\u5546\\u54c1":"\\u8305\\u6839150g","\\u5546\\u54c1\\u7f16\\u53f7":"00099","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"7.6","\\u91d1\\u989d":"38","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"190","\\u5546\\u54c1":"\\u9ec3\\u91d1\\u871c\\u85af500g","\\u5546\\u54c1\\u7f16\\u53f7":"00132","\\u6570\\u91cf":"3.826","\\u5355\\u4ef7":"9.2002","\\u91d1\\u989d":"35.2","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"191","\\u5546\\u54c1":"\\u9ec3\\u8c46\\u82bd300g","\\u5546\\u54c1\\u7f16\\u53f7":"00056","\\u6570\\u91cf":"8.75","\\u5355\\u4ef7":"4","\\u91d1\\u989d":"35","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"192","\\u5546\\u54c1":"\\u7626\\u8089","\\u5546\\u54c1\\u7f16\\u53f7":"00276","\\u6570\\u91cf":"0.7104","\\u5355\\u4ef7":"48.001100000000001","\\u91d1\\u989d":"34.1","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"193","\\u5546\\u54c1":"\\u9aa8\\u8169","\\u5546\\u54c1\\u7f16\\u53f7":"00285","\\u6570\\u91cf":"0.4321","\\u5355\\u4ef7":"77.99120000000001","\\u91d1\\u989d":"33.7","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"194","\\u5546\\u54c1":"\\u5ba2\\u5bb6\\u8c46\\u8150380g\\/\\u76d2","\\u5546\\u54c1\\u7f16\\u53f7":"00340","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"6.7","\\u91d1\\u989d":"33.5","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"195","\\u5546\\u54c1":"\\u80a5\\u8089","\\u5546\\u54c1\\u7f16\\u53f7":"00258","\\u6570\\u91cf":"6.64","\\u5355\\u4ef7":"5","\\u91d1\\u989d":"33.2","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"196","\\u5546\\u54c1":"\\u6c34\\u6771\\u82a5\\u83dc450g","\\u5546\\u54c1\\u7f16\\u53f7":"00013","\\u6570\\u91cf":"4.3422","\\u5355\\u4ef7":"7.5998","\\u91d1\\u989d":"33","\\u7b14\\u6570":"6","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"197","\\u5546\\u54c1":"\\u8c6c\\u8170\\uff08\\u500b\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00256","\\u6570\\u91cf":"4","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"32","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"198","\\u5546\\u54c1":"\\u6392\\u9aa8\\u7c92","\\u5546\\u54c1\\u7f16\\u53f7":"00272","\\u6570\\u91cf":"0.3625","\\u5355\\u4ef7":"88","\\u91d1\\u989d":"31.9","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"199","\\u5546\\u54c1":"\\u67b8\\u675e\\u8449180g","\\u5546\\u54c1\\u7f16\\u53f7":"00082","\\u6570\\u91cf":"8.5131","\\u5355\\u4ef7":"3.7002","\\u91d1\\u989d":"31.5","\\u7b14\\u6570":"9","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"200","\\u5546\\u54c1":"\\u6709\\u7b4b\\u8171","\\u5546\\u54c1\\u7f16\\u53f7":"00274","\\u6570\\u91cf":"0.3545","\\u5355\\u4ef7":"88.011300000000006","\\u91d1\\u989d":"31.2","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"201","\\u5546\\u54c1":"\\u5927\\u5e73\\u5305","\\u5546\\u54c1\\u7f16\\u53f7":"00010","\\u6570\\u91cf":"6.25","\\u5355\\u4ef7":"4.8","\\u91d1\\u989d":"30","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"202","\\u5546\\u54c1":"\\u87f9\\u5473\\u83c7150g","\\u5546\\u54c1\\u7f16\\u53f7":"00103","\\u6570\\u91cf":"5.0335","\\u5355\\u4ef7":"5.9601","\\u91d1\\u989d":"30","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"203","\\u5546\\u54c1":"\\u897f\\u6912550g","\\u5546\\u54c1\\u7f16\\u53f7":"00110","\\u6570\\u91cf":"2.6316","\\u5355\\u4ef7":"11.3999","\\u91d1\\u989d":"30","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"204","\\u5546\\u54c1":"\\u5976\\u767d\\u9945\\u982d45g*12\\u500b","\\u5546\\u54c1\\u7f16\\u53f7":"00145","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"15","\\u91d1\\u989d":"30","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"205","\\u5546\\u54c1":"\\u6d77\\u5e36\\u7d50200g","\\u5546\\u54c1\\u7f16\\u53f7":"00364","\\u6570\\u91cf":"4.758","\\u5355\\u4ef7":"6.2001","\\u91d1\\u989d":"29.5","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"206","\\u5546\\u54c1":"\\u8292\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00406","\\u6570\\u91cf":"3.0125","\\u5355\\u4ef7":"9.6598","\\u91d1\\u989d":"29.1","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"207","\\u5546\\u54c1":"\\u8c6c\\u7c89\\u8178","\\u5546\\u54c1\\u7f16\\u53f7":"00248","\\u6570\\u91cf":"0.7553","\\u5355\\u4ef7":"37.9981","\\u91d1\\u989d":"28.7","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"208","\\u5546\\u54c1":"\\u6885\\u982d\\u8c6c\\u6252","\\u5546\\u54c1\\u7f16\\u53f7":"00270","\\u6570\\u91cf":"0.4074","\\u5355\\u4ef7":"67.99209999999999","\\u91d1\\u989d":"27.7","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"209","\\u5546\\u54c1":"\\u76d2\\u88dd\\u8c46\\u82d7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00054","\\u6570\\u91cf":"4.508","\\u5355\\u4ef7":"6.1003","\\u91d1\\u989d":"27.5","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"210","\\u5546\\u54c1":"\\u76ae\\u86cb4\\u53ea","\\u5546\\u54c1\\u7f16\\u53f7":"00146","\\u6570\\u91cf":"3","\\u5355\\u4ef7":"9","\\u91d1\\u989d":"27","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"211","\\u5546\\u54c1":"\\u849c\\u82d7150g","\\u5546\\u54c1\\u7f16\\u53f7":"00120","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"5.3","\\u91d1\\u989d":"26.5","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"212","\\u5546\\u54c1":"\\u767d\\u7389\\u83c7150g","\\u5546\\u54c1\\u7f16\\u53f7":"00104","\\u6570\\u91cf":"4.0399","\\u5355\\u4ef7":"6.4358","\\u91d1\\u989d":"26","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"213","\\u5546\\u54c1":"\\u4e0a\\u6d77\\u96f2\\u541e\\u76ae\\uff08\\u767d\\u65b9\\u76ae\\uff09350g","\\u5546\\u54c1\\u7f16\\u53f7":"00207","\\u6570\\u91cf":"3","\\u5355\\u4ef7":"8.5","\\u91d1\\u989d":"25.5","\\u7b14\\u6570":"3","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"214","\\u5546\\u54c1":"\\u7d2b\\u8607150g","\\u5546\\u54c1\\u7f16\\u53f7":"00121","\\u6570\\u91cf":"5","\\u5355\\u4ef7":"5","\\u91d1\\u989d":"25","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"215","\\u5546\\u54c1":"\\u81a0\\u888b","\\u5546\\u54c1\\u7f16\\u53f7":"00300","\\u6570\\u91cf":"25","\\u5355\\u4ef7":"1","\\u91d1\\u989d":"25","\\u7b14\\u6570":"24","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"216","\\u5546\\u54c1":"\\u76d2\\u88dd\\u6787\\u6777","\\u5546\\u54c1\\u7f16\\u53f7":"00543","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"12.5","\\u91d1\\u989d":"25","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"217","\\u5546\\u54c1":"\\u9280\\u7d72\\u738b300g","\\u5546\\u54c1\\u7f16\\u53f7":"00005","\\u6570\\u91cf":"4.2105","\\u5355\\u4ef7":"5.7","\\u91d1\\u989d":"24","\\u7b14\\u6570":"5","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"218","\\u5546\\u54c1":"\\u8c6c\\u80332\\u53ea","\\u5546\\u54c1\\u7f16\\u53f7":"00261","\\u6570\\u91cf":"1.7058","\\u5355\\u4ef7":"14.069599999999999","\\u91d1\\u989d":"24","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"219","\\u5546\\u54c1":"\\u897f\\u862d\\u82b1\\u82d7200g","\\u5546\\u54c1\\u7f16\\u53f7":"00370","\\u6570\\u91cf":"2.1429","\\u5355\\u4ef7":"10.4998","\\u91d1\\u989d":"22.5","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"220","\\u5546\\u54c1":"\\u7da0\\u4e5d\\u82bd\\u751f\\u83dc300g","\\u5546\\u54c1\\u7f16\\u53f7":"00078","\\u6570\\u91cf":"4","\\u5355\\u4ef7":"5.5","\\u91d1\\u989d":"22","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"221","\\u5546\\u54c1":"\\u9bae\\u8611\\u83c7(\\u6d77\\u9bae\\u83c7)250g","\\u5546\\u54c1\\u7f16\\u53f7":"00106","\\u6570\\u91cf":"4.5832","\\u5355\\u4ef7":"4.8001","\\u91d1\\u989d":"22","\\u7b14\\u6570":"4","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"222","\\u5546\\u54c1":"\\u96ea\\u84ee\\u679c","\\u5546\\u54c1\\u7f16\\u53f7":"00330","\\u6570\\u91cf":"3","\\u5355\\u4ef7":"7","\\u91d1\\u989d":"21","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"223","\\u5546\\u54c1":"\\u8c6c\\u5fc3\\uff08\\u500b\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00249","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"10","\\u91d1\\u989d":"20","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"224","\\u5546\\u54c1":"\\u9752\\u6885","\\u5546\\u54c1\\u7f16\\u53f7":"00674","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"10","\\u91d1\\u989d":"20","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"225","\\u5546\\u54c1":"\\u8766\\u7c73\\u8178\\u7c89","\\u5546\\u54c1\\u7f16\\u53f7":"00202","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"9.5","\\u91d1\\u989d":"19","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"226","\\u5546\\u54c1":"\\u8c6c\\u5229\\uff08\\u689d\\uff09","\\u5546\\u54c1\\u7f16\\u53f7":"00250","\\u6570\\u91cf":"1","\\u5355\\u4ef7":"18","\\u91d1\\u989d":"18","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"227","\\u5546\\u54c1":"\\u62c9\\u9eb5350g","\\u5546\\u54c1\\u7f16\\u53f7":"00151","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"16","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"228","\\u5546\\u54c1":"\\u767d\\u8178\\u7c89","\\u5546\\u54c1\\u7f16\\u53f7":"00203","\\u6570\\u91cf":"2","\\u5355\\u4ef7":"8","\\u91d1\\u989d":"16","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"229","\\u5546\\u54c1":"\\u8525\\u9999\\u624b\\u6293\\u990597g*4\\u7247","\\u5546\\u54c1\\u7f16\\u53f7":"00417","\\u6570\\u91cf":"1","\\u5355\\u4ef7":"15.5","\\u91d1\\u989d":"15.5","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"230","\\u5546\\u54c1":"\\u99ac\\u9bab\\u9b5a\\u4e38250g\\/\\u5305","\\u5546\\u54c1\\u7f16\\u53f7":"00354","\\u6570\\u91cf":"1","\\u5355\\u4ef7":"15","\\u91d1\\u989d":"15","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"231","\\u5546\\u54c1":"\\u9694\\u5c71","\\u5546\\u54c1\\u7f16\\u53f7":"00240","\\u6570\\u91cf":"1.48","\\u5355\\u4ef7":"10","\\u91d1\\u989d":"14.8","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"232","\\u5546\\u54c1":"\\u5927\\u9752\\u8292","\\u5546\\u54c1\\u7f16\\u53f7":"00493","\\u6570\\u91cf":"0.8333","\\u5355\\u4ef7":"12.00050000000000061","\\u91d1\\u989d":"10","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"233","\\u5546\\u54c1":"\\u9b5a\\u8165\\u8349150g","\\u5546\\u54c1\\u7f16\\u53f7":"00059","\\u6570\\u91cf":"1.6982","\\u5355\\u4ef7":"5.2997","\\u91d1\\u989d":"9","\\u7b14\\u6570":"2","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"234","\\u5546\\u54c1":"\\u677f\\u6817\\u756a\\u85af","\\u5546\\u54c1\\u7f16\\u53f7":"00042","\\u6570\\u91cf":"0.869","\\u5355\\u4ef7":"8.4005","\\u91d1\\u989d":"7.3","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"235","\\u5546\\u54c1":"\\u513f\\u83dc","\\u5546\\u54c1\\u7f16\\u53f7":"00655","\\u6570\\u91cf":"0.6","\\u5355\\u4ef7":"11","\\u91d1\\u989d":"6.6","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"236","\\u5546\\u54c1":"\\u6c99\\u8591100g","\\u5546\\u54c1\\u7f16\\u53f7":"00115","\\u6570\\u91cf":"0.9091","\\u5355\\u4ef7":"4.4","\\u91d1\\u989d":"4","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"},{"\\u5e8f\\u53f7":"237","\\u5546\\u54c1":"\\u7d05\\u8525\\u982d\\uff08\\u540a\\u5e79\\u8525)100g","\\u5546\\u54c1\\u7f16\\u53f7":"00114","\\u6570\\u91cf":"0.6842","\\u5355\\u4ef7":"5.7001","\\u91d1\\u989d":"3.9","\\u7b14\\u6570":"1","\\u5151\\u6362\\u91d1\\u989d":"0"}]	{"items":[{"product_name":"\\u8c6c\\u8089100\\u5143","qty":77.3,"amount":7575,"unit":"\\u65a4"},{"product_name":"\\u8019\\u8019\\u67d1","qty":103.5702,"amount":714,"unit":"\\u65a4"},{"product_name":"\\u6e05\\u9060\\u96de1.1-1.3KG","qty":10.8384,"amount":672,"unit":"\\u65a4"},{"product_name":"\\u5730\\u5011\\u9999\\u8549","qty":80.629,"amount":640.2,"unit":"\\u65a4"},{"product_name":"\\u9ec3\\u82b1\\u9b5a","qty":10.8525,"amount":557.9,"unit":"\\u65a4"},{"product_name":"\\u7d05\\u8525(\\u9999\\u8525)100g","qty":135,"amount":472.5,"unit":"\\u65a4"},{"product_name":"\\u897f\\u862d\\u82b1","qty":37.9673,"amount":466.5,"unit":"\\u65a4"},{"product_name":"\\u738b\\u7acb\\u9be7","qty":10.5167,"amount":441.7,"unit":"\\u65a4"},{"product_name":"\\u6563\\u88dd\\u4e32\\u8304","qty":21.545,"amount":430.9,"unit":"\\u65a4"},{"product_name":"\\u69b4\\u69e4\\u756a\\u85af500g","qty":39.0279,"amount":405.9,"unit":"\\u65a4"},{"product_name":"\\u767d\\u8766\\u8089200g","qty":20,"amount":400,"unit":"\\u65a4"},{"product_name":"\\u849c\\u982d220g","qty":44,"amount":396,"unit":"\\u65a4"},{"product_name":"\\u80e1\\u863f\\u8514(\\u7d05\\u863f\\u8514)","qty":77.5687,"amount":395.6,"unit":"\\u65a4"},{"product_name":"\\u4e00\\u5b57\\u6392","qty":5.4154,"amount":389.9,"unit":"\\u65a4"},{"product_name":"\\u5c0f\\u85cd\\u8393","qty":27.6916,"amount":386,"unit":"\\u65a4"},{"product_name":"\\u9f8d\\u5d17\\u96de","qty":7,"amount":364,"unit":"\\u65a4"},{"product_name":"\\u58eb\\u591a\\u5564\\u68a8","qty":11.28,"amount":350,"unit":"\\u65a4"},{"product_name":"\\u82ad\\u6a02","qty":54.2846,"amount":345,"unit":"\\u65a4"},{"product_name":"\\u8591(\\u751f\\u8591)300g","qty":33,"amount":343.2,"unit":"\\u65a4"},{"product_name":"\\u9bae\\u96de\\u86cb","qty":18,"amount":324,"unit":"\\u65a4"},{"product_name":"\\u82e6\\u74dc","qty":23.6087,"amount":318.4,"unit":"\\u65a4"},{"product_name":"\\u5510\\u751f\\u83dc300g","qty":54.4644,"amount":315.9,"unit":"\\u65a4"},{"product_name":"\\u4e09\\u9ec3\\u96de","qty":6.4998,"amount":312,"unit":"\\u65a4"},{"product_name":"\\u6563\\u88dd\\u91d1\\u6854","qty":51.2846,"amount":303.7,"unit":"\\u65a4"},{"product_name":"\\u9bc7\\u9b5a","qty":7.185,"amount":287.4,"unit":"\\u65a4"},{"product_name":"\\u514d\\u6cbb\\u8c6c\\u8089","qty":4.9292,"amount":285.9,"unit":"\\u65a4"},{"product_name":"\\u9752\\u74dc","qty":31.4448,"amount":284.2,"unit":"\\u65a4"},{"product_name":"\\u767d\\u8611\\u83c7200g","qty":30.608,"amount":281.6,"unit":"\\u65a4"},{"product_name":"\\u4e0a\\u6d77\\u9752\\u82d7300g","qty":37.6985,"amount":279.8,"unit":"\\u65a4"},{"product_name":"\\u6c99\\u5f8b\\u83dc-\\u5e36\\u91ac150g","qty":25.7013,"amount":267.3,"unit":"\\u65a4"},{"product_name":"\\u82a5\\u862d\\u82d7300g","qty":31.551,"amount":260.7,"unit":"\\u65a4"},{"product_name":"\\u5510\\u751f\\u83dc\\u82d7250g","qty":28.0835,"amount":253.5,"unit":"\\u65a4"},{"product_name":"\\u8304\\u5b50(\\u7d2b)","qty":30.4197,"amount":253,"unit":"\\u65a4"},{"product_name":"\\u871c\\u8702\\u6a59","qty":41.6675,"amount":250,"unit":"\\u65a4"},{"product_name":"\\u99ac\\u9234\\u85af","qty":42.2657,"amount":248,"unit":"\\u65a4"},{"product_name":"\\u828b\\u982d","qty":18.9127,"amount":238.3,"unit":"\\u65a4"},{"product_name":"\\u767d\\u6d0b\\u8525","qty":47.28,"amount":236.4,"unit":"\\u65a4"},{"product_name":"\\u9752\\u901a300g","qty":34.5896,"amount":227.5,"unit":"\\u65a4"},{"product_name":"\\u756a\\u8304(\\u7c89)350g","qty":35,"amount":227.5,"unit":"\\u65a4"},{"product_name":"\\u82ab\\u831c70g","qty":65,"amount":227.5,"unit":"\\u65a4"},{"product_name":"\\u83e0\\u83dc\\u82d7300g","qty":21.429,"amount":225,"unit":"\\u65a4"},{"product_name":"\\u6c34\\u679c\\u6912250g","qty":17.307,"amount":225,"unit":"\\u65a4"},{"product_name":"\\u83e0\\u863f\\u871c","qty":16.086,"amount":220,"unit":"\\u65a4"},{"product_name":"\\u6c34\\u679c\\u6cb9\\u74dc400g","qty":24.717,"amount":218.6,"unit":"\\u65a4"},{"product_name":"\\u6ab8\\u6aac","qty":86.4,"amount":216,"unit":"\\u65a4"},{"product_name":"\\u767d\\u8c46\\u89d2300g","qty":25.6084,"amount":210,"unit":"\\u65a4"},{"product_name":"\\u6728\\u74dc","qty":27.6684,"amount":210,"unit":"\\u65a4"},{"product_name":"\\u4eac\\u5305","qty":49.4286,"amount":207.6,"unit":"\\u65a4"},{"product_name":"\\u677f\\u6817\\u5357\\u74dc","qty":24.0581,"amount":206.9,"unit":"\\u65a4"},{"product_name":"\\u9716\\u8089","qty":3.0015,"amount":204.1,"unit":"\\u65a4"}],"summary":"\\u5171\\u8bc6\\u522b50\\u884c\\u6709\\u6548\\u9500\\u552e\\u6570\\u636e\\uff0c\\u5b57\\u6bb5\\u6620\\u5c04\\uff1a\\u5546\\u54c1\\u2192product_name\\uff0c\\u6570\\u91cf\\u2192qty\\uff0c\\u91d1\\u989d\\u2192amount\\uff0c\\u65e0\\u5355\\u4f4d\\u5b57\\u6bb5\\u9ed8\\u8ba4\\u65a4\\u3002"}	2026-06-03 20:45:21	2026-06-03 20:45:49
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedules (id, store_id, employee_id, schedule_date, shift_start, shift_end, shift_type, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
zU9WBs80PmR1Pf2qkyWpN1Bzf3nsZDmEDXSmLQCK	\N	104.23.209.124	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVDhzVU5PNm85Wm43TWRhcHh0ZXN0MHg4bnhFNUNNVHlRU3psQndxYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781389758
WZIDxiHBEh7GRLvfvEZT3spcy74KKUeCQvMMx9qq	\N	113.215.189.173	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWnJWZjhMd3VRMHRIRlc5Y0dxRjI0cVF1cVpnQzBvQUZ4TkpXaWtEUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781419698
PPquXGv8BhisaSf6eWAU4k9BbXTXjCW5IyNHLWfu	\N	172.70.126.30	Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity	YTozOntzOjY6Il90b2tlbiI7czo0MDoiU0dUSlhISHNpaWJldjdxSWJkTlZRcjFkQldWd0FiN2JvOXdxUDg1VSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781453860
GnAYQMT8TlUX7gCCbc0IoFKJfnWRo0lpVzC1ZZwJ	\N	172.70.39.31	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaXljRzdvRVZnTVFLT3pDNHNJWjhjSVphNHE3NUxPOW9TMWRGOG9CYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781312046
hWo9uoZQ2m2DW82cvW5hq4bXjBJf89qxNmlzxV6Y	\N	95.217.109.26	Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWU3N0oxbExLNndpTUNCSDdCcGtsQ1lGdjB2WnNJNUhOdmNvRUhsTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781327424
vMQMIhoRptqPpQ0NxBNTLqTIKtm3kzvL6gw6Lk72	\N	172.70.214.77	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWldBNm1rR2NSMGZMNGJoMndSeE0wTm9MVGxyQTZuMEN3aXRkV0RnYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781354341
8fyWFx9EO5PYXVN0cinkaMp0XUGXutaPpURCLre0	\N	42.114.27.179	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUTlmU0Y5d1VGbkIxNk82NTdhemFGblg4VzdIakJDMmZNT1Bxb29XMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781383193
0F7WTNGAYyUbfhL3Em3mc0CAvMSaslO104NKrz7e	\N	104.23.209.124	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnRwcFZlbUNScnBWR2plNFBBOHU4OHMzZmdGY3BxQ0I5R3lzdmFrQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781389759
v8MgEkTtt8NFYM0KWwLW4n5VMAyOrEunnqdsBvWI	\N	205.210.31.12	Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity	YTozOntzOjY6Il90b2tlbiI7czo0MDoiMjJuZDVwY0FYb1Q3ZFllaFZXeGpNMHNBMGRvU0pkWlRsQ2FObHpNaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781424536
QXDhoruM1vNl1uPkAsDCee8bi09pBT5kJeTMG1TV	\N	104.23.162.102	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVjBsT1dhOUQ0aEpNRnozRjRjUFh4ZmlTUjFOUk9IWERHeHhoOWh3ZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781455933
f98NeqcdTwlCcHam6UYWDjc62TwhXhGlii6bMHwe	\N	172.69.59.20	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiS2pJNUZjb1JuVUlDNGl6dkhUQnhjM1RxMUlnc2RyMFA1VFB6WDNjTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781313283
egjTdxw0DsUu2xFJxoaVjeWEEZv1LP2frJy8IW32	\N	95.217.109.26	Mozilla/5.0 (compatible; MJ12bot/v1.4.8; http://mj12bot.com/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ2l2Q3lhV0U2VjFjaFZvZm5YREU4WU43ZFhTU2RjRFliY0hKR3RkeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781327430
PKdGyMPoU22TL8e2jbdbqtGjgZTz2ElOe1RsZsKZ	\N	172.70.207.189	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNjM4NHU2czh6bXQxNHRXdmRnQmEwM203cUFrYUhqRFN3SVpONmZzbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781355349
DKYK6fBjPzkWy8VTQVAIngjYou8YVMq3Dla9CmwZ	\N	172.69.59.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjZOcEFuU3dKMkNNUEpsUTlVN3k1S0NjR05kM3RLYlhXc1Q1VmFlNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781388632
gv4c4Iibdzfod7pVbmkfRKo45gPeffZ8v0R7TTou	\N	3.151.194.164	visionheight.com/scan Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFpNcm1QOXFKUGUzRk5uemlBdGo3ZG1ZYzBlRnBheVFzSXBPVmxGeCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781390910
DOX7kaZvScQCAVY9CE8QNeOsZBBFPKE7lMEVOAvL	\N	162.158.166.211	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGYwQWs4UEdzU21ZSG80RTJMc2JQWTlrNWRYSmlMdnlaUWlpclBmbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781413553
jCyCOuKFnCYYKDb346ieN25VKp2p5R0prGxTlw0c	\N	104.22.64.12	Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTWc2Y2VkTGU5UldWOGF1QmdYYlF1WWVMTGVFeGxnczBPTVBmU3NMTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781424688
XSff6W9S6wBUuEGQxEYcxUsmvh4pih9qTzjDC1Bo	\N	172.68.50.63	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRnFqMDFFVXF0Y0FsT2xxaWg2ZjlRS3E5T1I3OU5xN1VXcU1KYnowNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781455940
SFB9UylSuy2xWtENeD3td5yNTFyKtWFoDwjeo02x	\N	172.69.58.124	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiemZpWmx2YzJUeXZPamxHOVBLdFZqUFZrZWlpQkZUdGhQSkFpT2xqTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781313288
rLTyxiLtAHLiDIfhiKingRUn3DoZFXGVGIxwMdif	\N	104.23.213.28	Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.7778.96 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaXVQUzJxakxpSmFjRm94cnFNMDdPYUpETkJCamxmd3JvRXc5QUQxMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781330045
kXluGnDP4nLXScpFPRVanqAaWdrcUQxlQlhutWgp	\N	172.70.46.179	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoibzBVN2FsWWZxQUMzSFpPYlMwa1F3Z1NQanhJaVIzRTJ5WWNSbGZVUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781356140
KRNbXfCeKdjU8vtMfsWe1WOXQ1lAvmhUuA1r3Sfe	\N	172.69.59.19	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNExTRHlHTzMzSXQydnFodXNvRmo0WjNEVG9BWXlaYlJjOVpRNzFiUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781388633
fqp6vVrkHjAdl744SicDBg3z2KjIRm2eLPTiO10C	\N	93.123.109.52	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0VlajFJNjBjbHdVZFFhM0lMMzA2UjlFTDRYNU1MVnM5dUdpY2t0TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781414184
wNuNLrmxCpkT4ILkLdlzpFmCYLZ5foSHAciO8EUS	\N	104.23.166.12	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiOTZMNDQ5MHdvYzR1cW9vRnNjbTFOTUNJc0xRVXhqWU43c3VrZjlOYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781443880
JkQjSRBqI8YXwQxGi4UbTQwsNURE7SHLNCYTfbNZ	\N	172.71.152.86	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoic0xSS201MEd4cTBsa2tTQmNRNFNtbmFaMnlHZUlZZ1czYXNDWXN3RyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781459467
GXnkUIVsSNgBLcGrU1pUBt2cAujHzch6iY2H2T14	\N	57.141.2.25	meta-externalagent/1.1 (+https://developers.facebook.com/docs/sharing/webmasters/crawler)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWlhidkFDTlRlMmRjazBwUDZWbE16a09ka3hRbnNGdVk3cHpXOGFMdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781334608
z54rGAmyapryusZQ6eBETBoSGtpEHciSA5j99XRR	\N	172.71.95.52	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTVNkN3RrcHI0REgwTzFyRnQyclpKVUdOTVhERHY3MnRKNUh4c0VqayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781360648
05FW7ertgZPtYjdq6VmVpopf3vOLBJYLgSKO0hWT	8	119.28.6.161	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	YTo3OntzOjY6Il90b2tlbiI7czo0MDoiZk5qblBCeHhLUjFzUURONzNSblo2QjRsckJINm95U0tjV1g2b3lINyI7czozOiJ1cmwiO2E6MDp7fXM6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjMzOiJodHRwczovL3BhcGVyLnhpbmdrZTg4OC5jb20vYWRtaW4iO3M6NToicm91dGUiO3M6MzA6ImZpbGFtZW50LmFkbWluLnBhZ2VzLmRhc2hib2FyZCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjg7czoxNzoicGFzc3dvcmRfaGFzaF93ZWIiO3M6NjQ6Ijg0MGU0ODFlZWQ0Y2QzNWZhYjhkMTEwNTMwM2MyMTBiMWJlYzZlYmQ0NDQzNTUyODk3ZThiOTQwYjIxNjVlYTgiO3M6NjoidGFibGVzIjthOjE6e3M6NDA6IjczZjlmYTU1ODM0ZjAzYjZkNTIyZWJiNGZkNDA4ZmU4X2NvbHVtbnMiO2E6ODp7aTowO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjEwOiJzdG9yZS5uYW1lIjtzOjU6ImxhYmVsIjtzOjY6IumXqOW6lyI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjE7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTI6InByb2R1Y3QubmFtZSI7czo1OiJsYWJlbCI7czoxMjoi5ZWG5ZOB5ZCN56ewIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MjthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMjoicHJvZHVjdC51bml0IjtzOjU6ImxhYmVsIjtzOjY6IuWNleS9jSI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjM7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTE6ImN1cnJlbnRfcXR5IjtzOjU6ImxhYmVsIjtzOjEyOiLlvZPliY3lupPlrZgiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aTo0O2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjg6ImF2Z19jb3N0IjtzOjU6ImxhYmVsIjtzOjEyOiLlubPlnYfmiJDmnKwiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjoxO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7YjowO31pOjU7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6Imxhc3RfaW5fYXQiO3M6NToibGFiZWwiO3M6MTI6IuacgOi/keWFpeW6kyI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjE7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtiOjA7fWk6NjthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMToibGFzdF9vdXRfYXQiO3M6NToibGFiZWwiO3M6MTI6IuacgOi/keWHuuW6kyI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjE7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtiOjA7fWk6NzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMjoibGFzdF9zb2xkX2F0IjtzOjU6ImxhYmVsIjtzOjE4OiLmnIDlkI7plIDllK7ml7bpl7QiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjoxO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7YjowO319fX0=	1781414292
Mixz4acJNLpijktdAoPfhcAN6vSRa8twJA7SqRT7	\N	172.69.6.219	Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiYWVnZXd0T05ZMWh0M01RZ0dPa2pNeHlrMnc3OWFzblBHaGlyTWRlTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781448498
RnZH7EBP8h1cEaItVnDvl3hQlAzFux8U2HzJ27AY	\N	172.70.39.32	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; PerplexityBot/1.0; +https://perplexity.ai/perplexitybot)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUGJaMDZuRzYwejBGcGpFV2FhT3IxRHk0eGF3OTVIMXJ3cVF4aDlGSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781466001
9ereZJGGgJjzckw9Dh5Tnuu6a8qezfcfkqX21fGx	8	60.246.217.157	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	YTo3OntzOjY6Il90b2tlbiI7czo0MDoicTFLUFh0dWdNWWpCNXpIekNLcjdTZWtQSk5acUV3UXBCblN3Q0pLYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbiI7czo1OiJyb3V0ZSI7czozMDoiZmlsYW1lbnQuYWRtaW4ucGFnZXMuZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODtzOjE3OiJwYXNzd29yZF9oYXNoX3dlYiI7czo2NDoiODQwZTQ4MWVlZDRjZDM1ZmFiOGQxMTA1MzAzYzIxMGIxYmVjNmViZDQ0NDM1NTI4OTdlOGI5NDBiMjE2NWVhOCI7czo2OiJ0YWJsZXMiO2E6MTp7czo0MDoiN2UwMzFmM2E4OTk5NjJhMWEwMjNmYjA2YmY0YjAzYzlfY29sdW1ucyI7YTo2OntpOjA7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6NToiZW1vamkiO3M6NToibGFiZWwiO3M6Njoi5Zu+5qCHIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MTthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo0OiJuYW1lIjtzOjU6ImxhYmVsIjtzOjEyOiLooYzkuJrlkI3np7AiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToyO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjQ6InNsdWciO3M6NToibGFiZWwiO3M6Njoi5qCH6K+GIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo1OiJ0aXRsZSI7czo1OiJsYWJlbCI7czoxMjoi5ZOB54mM5qCH6aKYIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6NDthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo3OiJlbmFibGVkIjtzOjU6ImxhYmVsIjtzOjY6IuWQr+eUqCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjU7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6InNvcnRfb3JkZXIiO3M6NToibGFiZWwiO3M6Njoi5o6S5bqPIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fX19czo4OiJmaWxhbWVudCI7YTowOnt9fQ==	1781315459
W6Tdl3otmAs1nfYe9WxYdJuIs9fydYrpn72GCmfo	\N	162.158.216.71	Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiT1JTd254UFdCOXh4blp2YVRrdHBFRU90N01XZlBrblN4UVBYNGtTaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781340842
1WGVZ5tlY0GlSKBzalTfZ949fA5zSGSwuuwssE0b	\N	172.71.102.21	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiajBiWUpJUlpWRFdUUjA3SVFBTUJmVkJ3d1NKdkhxOUhLa0FsdklpSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781360649
FannZBqrWedARElcJ7FFSBK9FUhNc4lQWBRMbdGA	\N	18.145.140.245	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36	YTo0OntzOjY6Il90b2tlbiI7czo0MDoiNlBEeVZyM2dtWlY1TnZoSnJuV3lLaVJKRWJwcGtZTVRGT3BlazQydyI7czozOiJ1cmwiO2E6MTp7czo4OiJpbnRlbmRlZCI7czozMzoiaHR0cHM6Ly9wYXBlci54aW5na2U4ODguY29tL2FkbWluIjt9czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781310153
DiZIo06pStKcR643VBayi7tVmUr6ub67ASHWzP6g	\N	112.94.252.66	Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoibzRVcHpzamNQWkI1Q2I2c25LbldBeUtjcVFWUERwYXJzUG9TeWVyaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781317402
bocLUEnwqoGuWqptqqm839XulHkEwc1SzFdjTEkO	\N	172.71.255.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUVJRmwzeEo0NGp3bzJHYU9GSFZRMTdYNnhxREpJcEVsSWZSMHlMeiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781341805
SfZjQlQQJxeiAvqeabuDGoRQz7SLlpPdA4F6j8H4	\N	42.114.27.179	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSWRKVWVtbGZDb0t2MnZ2TmpNV2djR3huMkJ2cEl4MngxMUtndmF4UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781361976
xnGQOHfsVZ8xFk0neZPLXtyIp1NaDFT5YRFpELKm	\N	162.158.187.69	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHNqaURDWnJrS2hLZVFWZ0xzQ0IxS3U4WUJlVkZITW5OT1JvZno2QyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781417982
X4AIHNyGqD1bXu30mFkMQcYs0ufjFnimH7dhdtsR	\N	104.23.211.78	Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRk9yNGZnQVQ1elh0WEM0VnE4ajNHY0lJOExocGY4TUhMOEVjMDZvQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781449154
MZqNnts6KSvBlkz0sPMwTKVbb1vBWs59dK3J7awX	\N	104.23.209.211	Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; PerplexityBot/1.0; +https://perplexity.ai/perplexitybot)	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWowbFd6bXlHVDR5VWJSV0puSXpraHlLcktQSDJNUk8yTnE0MkpSWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781466006
txV7RPy2VIAHeoopdxw8swa9gAHEamsCljdxLFwT	\N	176.65.139.231	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSnJwVDZwdVp2cHRtaE15aHdReHNoZUJtOWJIYm5saEZpS2tPSllyTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781398128
oMVznAWAnKrlYEzyc2CSc0XUSbCi9tNthqhxpeWr	\N	104.23.251.113	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaVA4Q2VhMVVScVNiekdOT0oxb0I3OGZKYm52eFV5TlZtNEFhckpKQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781418221
OJMd6y9om1VcVwwFEgV43nInrcpCUx0fv1Usr2F1	\N	208.84.100.201	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZXFYcEFaR3BxTFI4anVhdEFYeXJ6RUo2SEtmVVlXNHdBcHdIT3hhYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781323028
UlWN9WtAagD2TKZU2gSYhhb0w7F857TXdyCnrZMG	\N	172.71.255.100	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzVibGtCY0VtQmVJYTFTRUZ2UHZSTFZ0R2pBMU92eHpSU0NZOWdteSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781341806
yoDo5F1bgmHiwZwApnPAzGrr4hGFBqij4Ajl6kEs	\N	81.71.101.51	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Mobile Safari/537.36 MicroMessenger/7.0.1	YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3JSbWsxZ3NBUVN3Qm40TTJFb2xFczlGNWozV0ZxZ09OOFZqNVZ2TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781366531
clxQEWO0ldvrqiHeahe4hS3TKux3incmWDQxj6Qr	\N	162.158.152.153	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiRDZIZGVYU01TU21udHYwcWRKQ0JwUk1DUkxEWVVJSmEyck5VY0w3YiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781449834
GVFkq93HBfJtFI7UyyP6ZaiZGGXY8ZIFQaOcR5GN	\N	104.22.104.173	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiV2JFZU4wUk9zYm1HSHRCVGk3aXkxNHhXSWZpb2dZUERTSGlRTm5XdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781399174
OUSWIvozEzHnZbltvjw6qjvB5MRzwzF5h48mI5O8	\N	104.23.197.36	visionheight.com/scan Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSUdycW9aanMxczB3RkE3aWoxUEJwdlJDMThSN05WWkxGekNGSWhyMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781419245
X0GP8G7IU60qSkxJIDDDOF6X82GPYb8k3SFQbZPp	\N	208.84.100.201	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiOE5kUkx6b2V0ZFd6cktyTWtFcThISDlnQ0lUQ3ZWczE4QUV0MW12WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781323028
6UaJYGSIt5K05yGOzLT4Z4eTTdEwEFa1Jztty4aZ	\N	104.23.229.137	Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNndTTmV5NjhpNVNGS2VPOFRZSWttb0dmc0tGcXlpWldNTlVXaEhadCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781350103
MQXEfbdRcZ4nqVx8x3quZo8BXMUmlChJDuljg68s	\N	172.70.111.68	Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVlhVdFdyVkFrRllBUHJNN1hIbDdPQWVsUkRwUDE1bE1RZ3pYelJVTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781370296
FNdpqKOZWJ9w5Bs8iXwVfVuOf4N7Nabc2ls6LVZA	\N	162.158.152.153	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiNHJDWmkwc0ExbWJjMW9ZVlZUdjBISktUY2NJMXNNUEJsZ1FlWGZWaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781449835
l87zsghXex8yumurE66DvTEKLWs108o4SconI9qT	\N	104.22.104.173	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVzFWQmJ3SjVlY2dibnNJbnBzNUtER2dXTXVvQU1qNWw2NFVSS1UwdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781399175
i97Eg7HnOLnWX5kITrbgK1MOOUv4sA05nW790L6x	\N	104.23.197.36	visionheight.com/scan Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoic1hVZzhZN3dJamtqNFhjd3RGcHhkTUY5VzdZMkJCTU82cmJadVFzcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781419334
V1a42Ez8JUetaCPKpSRjLC5Kl2C70D6OOwcm7ko7	\N	104.23.166.62	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiejFoWWxyYVNKSHdBNG5ueXY4YUUyd2RZNVZSMnU3MUxNYTlUeTBTQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vcy54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781451759
lZaresN8jECc8iMysepnKXOpyZcyhHE5uOIXdLQo	\N	208.84.100.201	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ21nbEpjVjl5ZjB2Y3YyWmg0MUpXNDNHbEZDaU5POXdkem9HcWhacyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781323033
OTZq0l5kFUZEMw61KVvaxJhA7C6cYFMHxFBz0Jyo	\N	172.71.222.217	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUxiVlNVNnVCd3V6ZXRLcHZxdkJxcjM4MWdkeDdVNDNUc0N1WkdpQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781350298
3DDGlukN8jhiC1N1kUnZos7isQFpkdFgRC1uKN4D	\N	119.28.6.161	Mozilla/5.0 (Linux; Android 15; MEIZU 22 Build/AQ3A.250411.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/146.0.7680.178 Mobile Safari/537.36 XWEB/1460205 MMWEBSDK/20260502 MMWEBID/3517 MicroMessenger/8.0.74.3120(0x28004A36) WeChat/arm64 Weixin NetType/4G Language/zh_CN ABI/arm64 miniProgram/wx81855e163e189a51	YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHZmWUM4VjJwQTFTZU0wVUpLQU80ZlkzbXlHUnU2N205TWwzQVdXMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781377437
knVHxs7PFbq3wMENJ1XIZ7gOMeX0nEIqOH9kQx7e	8	43.250.244.176	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	YTo3OntzOjY6Il90b2tlbiI7czo0MDoibkNNT0VXbmpFV0E5WVFVeWZ4Mjdob1FGdEhsNnZKMlZGYWFPUXpUbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9tZW51LXRlbXBsYXRlcyI7czo1OiJyb3V0ZSI7czo0NToiZmlsYW1lbnQuYWRtaW4ucmVzb3VyY2VzLm1lbnUtdGVtcGxhdGVzLmluZGV4Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6ODtzOjE3OiJwYXNzd29yZF9oYXNoX3dlYiI7czo2NDoiODQwZTQ4MWVlZDRjZDM1ZmFiOGQxMTA1MzAzYzIxMGIxYmVjNmViZDQ0NDM1NTI4OTdlOGI5NDBiMjE2NWVhOCI7czo2OiJ0YWJsZXMiO2E6Mjp7czo0MDoiN2UwMzFmM2E4OTk5NjJhMWEwMjNmYjA2YmY0YjAzYzlfY29sdW1ucyI7YTo2OntpOjA7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6NToiZW1vamkiO3M6NToibGFiZWwiO3M6Njoi5Zu+5qCHIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MTthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo0OiJuYW1lIjtzOjU6ImxhYmVsIjtzOjEyOiLooYzkuJrlkI3np7AiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToyO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjQ6InNsdWciO3M6NToibGFiZWwiO3M6Njoi5qCH6K+GIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MzthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo1OiJ0aXRsZSI7czo1OiJsYWJlbCI7czoxMjoi5ZOB54mM5qCH6aKYIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6NDthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo3OiJlbmFibGVkIjtzOjU6ImxhYmVsIjtzOjY6IuWQr+eUqCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjU7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTA6InNvcnRfb3JkZXIiO3M6NToibGFiZWwiO3M6Njoi5o6S5bqPIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fX1zOjQwOiJlMDNhOTNlM2FjMDFlYjg5MDczZTNhMDg0ZDRkM2ZhYV9jb2x1bW5zIjthOjU6e2k6MDthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo4OiJpbmR1c3RyeSI7czo1OiJsYWJlbCI7czo2OiLooYzkuJoiO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9aToxO2E6Nzp7czo0OiJ0eXBlIjtzOjY6ImNvbHVtbiI7czo0OiJuYW1lIjtzOjQ6Im5hbWUiO3M6NToibGFiZWwiO3M6OToi5qih54mI5ZCNIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6MjthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czo5OiJpc19hY3RpdmUiO3M6NToibGFiZWwiO3M6MTI6IuW9k+WJjeeUn+aViCI7czo4OiJpc0hpZGRlbiI7YjowO3M6OToiaXNUb2dnbGVkIjtiOjE7czoxMjoiaXNUb2dnbGVhYmxlIjtiOjA7czoyNDoiaXNUb2dnbGVkSGlkZGVuQnlEZWZhdWx0IjtOO31pOjM7YTo3OntzOjQ6InR5cGUiO3M6NjoiY29sdW1uIjtzOjQ6Im5hbWUiO3M6MTk6InF1aWNrX2FjdGlvbnNfY291bnQiO3M6NToibGFiZWwiO3M6OToi5oyJ6ZKu5pWwIjtzOjg6ImlzSGlkZGVuIjtiOjA7czo5OiJpc1RvZ2dsZWQiO2I6MTtzOjEyOiJpc1RvZ2dsZWFibGUiO2I6MDtzOjI0OiJpc1RvZ2dsZWRIaWRkZW5CeURlZmF1bHQiO047fWk6NDthOjc6e3M6NDoidHlwZSI7czo2OiJjb2x1bW4iO3M6NDoibmFtZSI7czoxMDoic29ydF9vcmRlciI7czo1OiJsYWJlbCI7czo2OiLmjpLluo8iO3M6ODoiaXNIaWRkZW4iO2I6MDtzOjk6ImlzVG9nZ2xlZCI7YjoxO3M6MTI6ImlzVG9nZ2xlYWJsZSI7YjowO3M6MjQ6ImlzVG9nZ2xlZEhpZGRlbkJ5RGVmYXVsdCI7Tjt9fX1zOjg6ImZpbGFtZW50IjthOjA6e319	1781401767
mw7fP4efVphSsb6POp89hC4hDdFOo5zbHm1pTnL2	\N	208.84.100.201	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiZndBMjhkaDlZaVhQWHFXMXhnNWhsVUlLOWtHWk8wRzZNV2V1SElsQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781323038
iVtdHatUlx8bMNTNOOPtYBWrHyo8Hd1b29jiZupI	\N	172.71.222.217	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiWEdTTU1GckFVSGRudXRTRjl4cnBibXlNSzVsZ0dlbTYybndjMzF6TSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781350304
KCHQIerqYGzOMYJQBiISUAcHZ3wWOfC7Fii5tbPn	\N	104.23.162.103	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiMWttNm9sUFdwUHJjTjlJNTg5QVhNVDVsc1ZKY2pUWGg4MGRUV1ZKMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781380697
zvU4txEz2fdl1ZOutwJqJVgKG6hPCkotnm4IjXIu	\N	113.215.189.172	Mozilla/5.0 (Linux; Android 9; ASUS_X00TD; Flow) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/359.0.0.288 Mobile Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiaGNnZnJVOXdvZDRyVVFoc20zQVBRRXJtcVpqak5qM0dKaElYcTBKZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzk6Imh0dHBzOi8vcGFwZXIueGluZ2tlODg4LmNvbS9hZG1pbi9sb2dpbiI7czo1OiJyb3V0ZSI7czoyNToiZmlsYW1lbnQuYWRtaW4uYXV0aC5sb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1781419500
GsIuS4SEDpx3M0lYdo1cfy5sYQvgMFGLsFDYBqAS	\N	141.101.76.28	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	YTozOntzOjY6Il90b2tlbiI7czo0MDoiazZ1ZFFkNHptSVBKaFAwWEE1MVcxaGRKUlFmSDFTQ2xVQ2lOMkZlUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDE6Imh0dHBzOi8vY29tcGFueS54aW5na2U4ODguY29tL2FkbWluL2xvZ2luIjtzOjU6InJvdXRlIjtzOjI1OiJmaWxhbWVudC5hZG1pbi5hdXRoLmxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1781451967
\.


--
-- Data for Name: stores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.stores (id, organization_id, region_id, name, code, address, province, city, district, latitude, longitude, manager_user_id, business_hours, status, settings, opened_at, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	筲箕湾店	SQW	香港铜锣湾	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	2026-03-22 14:54:14	2026-03-31 09:20:30	\N
2	1	1	西湾河店	XWH	西湾河筲箕湾道 18 号地铺	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
3	1	1	湾仔店	WCH	湾仔骆克道 88 号地铺	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	2026-03-22 08:02:05	2026-03-22 08:02:05	\N
4	1	1	舌尖团购店	TG	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	2026-03-31 09:20:30	2026-03-31 09:20:30	\N
\.


--
-- Data for Name: supplier_products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.supplier_products (id, supplier_id, product_id, supplier_product_code, purchase_price, min_order_qty, delivery_lead_days, is_primary, price_effective_date, price_expired_date, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	\N	1.20	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
2	1	2	\N	3.50	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
3	1	3	\N	0.80	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
4	1	4	\N	2.50	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
5	1	5	\N	2.80	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
6	1	6	\N	1.00	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
7	1	7	\N	1.50	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
8	1	8	\N	4.50	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
9	1	9	\N	3.20	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
10	1	10	\N	3.80	10.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
11	2	11	\N	18.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
12	2	12	\N	12.50	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
13	2	13	\N	55.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
14	2	14	\N	22.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
15	3	15	\N	28.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
16	3	16	\N	65.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
17	3	17	\N	12.00	5.000	1	t	\N	\N	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
18	1	18	\N	2.50	5.000	1	t	\N	\N	2026-03-22 08:27:41	2026-03-22 08:27:41	\N
19	1	19	\N	1.80	5.000	1	t	\N	\N	2026-03-22 08:27:41	2026-03-22 08:27:41	\N
20	1	20	\N	2.20	5.000	1	t	\N	\N	2026-03-22 08:27:41	2026-03-22 08:27:41	\N
21	1	21	\N	68.00	5.000	1	t	\N	\N	2026-03-22 08:27:41	2026-03-22 08:27:41	\N
\.


--
-- Data for Name: supplier_refund_claim_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.supplier_refund_claim_items (id, claim_id, damage_record_id, product_id, product_name, qty, unit_cost, claimed_amount, purchase_order_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: supplier_refund_claims; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.supplier_refund_claims (id, store_id, supplier_id, claim_no, status, total_items, total_qty, total_amount, submitted_at, resolved_at, notes, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.suppliers (id, organization_id, name, code, contact_name, contact_phone, contact_wechat, address, business_license, payment_terms, payment_days, delivery_lead_days, rating, status, notes, created_at, updated_at, deleted_at) FROM stdin;
1	1	新鲜直送农场	SUP001	陈老板	9123 4567	\N	\N	\N	2	30	1	5	1	专供蔬菜水果，每日早上 7 点送货	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
2	1	港鲜肉类批发	SUP002	黄先生	9876 5432	\N	\N	\N	1	0	1	4	1	供应猪肉、鸡肉、牛肉，现款现货	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
3	1	南海水产行	SUP003	李姐	6688 9900	\N	\N	\N	2	15	1	4	1	鱼虾蟹贝类，当日早市配送	2026-03-22 08:02:06	2026-03-22 08:02:06	\N
\.


--
-- Data for Name: user_store_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_store_roles (id, user_id, store_id, region_id, role_id, granted_by, granted_at, expired_at) FROM stdin;
1	3	2	\N	3	\N	2026-03-22 11:51:32	\N
2	9	2	\N	3	\N	2026-03-30 14:25:46	\N
3	1	2	\N	4	\N	2026-04-03 21:51:09	\N
4	2	1	\N	4	\N	2026-04-03 21:51:09	\N
5	4	2	\N	4	\N	2026-04-03 21:51:09	\N
6	5	1	\N	4	\N	2026-04-03 21:51:09	\N
7	6	2	\N	4	\N	2026-04-03 21:51:09	\N
8	8	4	\N	3	\N	2026-04-03 13:51:09	\N
9	10	1	\N	4	\N	2026-04-03 21:54:08	\N
10	11	3	\N	3	\N	2026-04-03 14:19:34	\N
11	8	3	\N	1	\N	2026-04-04 07:39:21	\N
12	12	1	\N	4	\N	2026-04-26 19:25:27	\N
13	13	1	\N	4	\N	2026-04-28 12:45:31	\N
14	14	1	\N	3	\N	2026-05-11 05:19:05	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at, is_admin, username) FROM stdin;
1	Demo User	demo@example.com	2026-03-15 15:56:51	$2y$12$vYFRQg19tWheyD5urZKYA.3wFAvdn5tsBq5mNfWfmO8Ogz8INznC2	kMV5C03Trm	2026-03-15 15:56:52	2026-04-27 21:36:35	f	demo
2	Mr. Erick Stracke DDS	uconn@example.com	2026-03-15 15:56:52	$2y$12$b7y0NJbCSJGYK8i1Fx5FUu28LTEDhb2tskuSkoGvxUqN4z1iFAyJ2	gFg8KcsRXo	2026-03-15 15:56:52	2026-03-15 15:56:52	f	\N
3	郑志远	zakary.beatty@example.org	2026-03-15 15:56:52	$2y$12$qOd/ZZy9F1nIy2VJwci1B.YcBSWh0bfsd0SP063CqauSAN5QqweAa	4O1Xt3vsX1dgLSIhvtSDDAJUtf0qeRSL1uI2EHH2sVV07N9ZstyumicYucGz	2026-03-15 15:56:52	2026-03-22 12:05:53	t	\N
4	Isidro Kuhic	jacklyn21@example.org	2026-03-15 15:56:52	$2y$12$b7y0NJbCSJGYK8i1Fx5FUu28LTEDhb2tskuSkoGvxUqN4z1iFAyJ2	5aPflhhhIf	2026-03-15 15:56:52	2026-03-15 15:56:52	f	\N
5	Ernest Ryan	clang@example.org	2026-03-15 15:56:52	$2y$12$b7y0NJbCSJGYK8i1Fx5FUu28LTEDhb2tskuSkoGvxUqN4z1iFAyJ2	pE5vo5wTqp	2026-03-15 15:56:52	2026-03-15 15:56:52	f	\N
6	Marina Mraz	odie66@example.org	2026-03-15 15:56:52	$2y$12$b7y0NJbCSJGYK8i1Fx5FUu28LTEDhb2tskuSkoGvxUqN4z1iFAyJ2	ovNcPtP9kb	2026-03-15 15:56:52	2026-03-15 15:56:52	f	\N
9	西湾河店员	xwh@sjtxg.com	\N	$2y$12$gIQOzaPNfmawuGCEmxUanO3/GB6CqXlQM2Ri0Q3s2IFVR/SmhmTB6	\N	2026-03-31 06:25:46	2026-03-31 19:18:13	f	\N
10	测试用户	test_reg@example.com	\N	$2y$12$RM3tpHI.2Gl0p9W1gaZ70OWm90W/VBTt2LjWshuPKd9cdOBMlwosy	\N	2026-04-03 21:54:08	2026-04-03 21:54:08	f	\N
11	david	david@gmail.com	\N	$2y$12$G14yeYDkvXkBbRk1lF..IOrnd5n8JudbgAqOOih6rKvv/C2DI1rLG	h0LjILX9jzHp4gtkcaRPm0f2NKeCerqzvfm5rYr6rdknjVCjrkvKIlOdjmbk	2026-04-04 06:19:46	2026-05-26 18:06:38	f	\N
12	david	david@xingke888.com	\N	$2y$12$..jINJlhtwLAYzKmztgycuzrgasjGylx.jBNAvp4b5SoOBcFWxSCC	\N	2026-04-26 19:25:27	2026-05-26 18:22:52	f	david
13	KT	keith@zcrun.com	\N	$2y$12$66Jx6LIwZq3G.QKPnZR2duc2/CmfpjMrT/nJpvDmPeCB2fvzEpQHa	\N	2026-04-28 12:45:31	2026-04-28 12:45:31	f	112233
14	tom	admin123@sjtxg.com	\N	$2y$12$VkP9qBx1WwJ9yltR0EQ4/OXQqrcotHmME83RmVVxAOfwzpO65CYkq	\N	2026-05-11 05:19:26	2026-05-11 05:19:26	f	\N
8	超级管理员	admin@sjtxg.com	\N	$2y$12$x494T/.0SmlE13bii40N3./nwug/reyxFreoPy41rdUF/PURZdaHy	sckO26foKaXwWq1i3HfAdmFZiatCAQgOZpyRcsXccNMbgoFaAFzNZlSFjwUB	2026-03-22 07:08:58	2026-04-04 07:39:33	t	admin
\.


--
-- Data for Name: weather_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.weather_logs (id, store_id, date, city, weather, temperature_high, temperature_low, humidity, rain_probability, uv_index, description, created_at, updated_at) FROM stdin;
1	3	2026-04-16	香港	多云转阵雨	26	22	78	60	6	午后有阵雨，可能影响客流，建议生鲜门店加强易腐商品保鲜措施并备好雨具供顾客使用。	2026-04-17 00:05:27	2026-04-17 00:05:27
2	2	2026-04-26	香港	多云	28	23	75	20	7	多云天气，气温适宜，客流正常。注意湿度较高，生鲜商品需加强保鲜措施。	2026-04-26 18:21:08	2026-04-26 18:21:08
3	1	2026-04-27	香港	多云	26	22	82	45	6	多云潮湿，易有零星阵雨，室外客流可能略降，生鲜注意防潮保鲜，叶菜类需加快周转。	2026-04-27 22:22:59	2026-04-27 22:22:59
4	2	2026-04-28	香港	阵雨	26	22	88	80	4	预计有阵雨，客流可能略降，请注意生鲜防潮和易腐商品及时补货与储存。	2026-04-28 08:49:09	2026-04-28 08:49:09
5	1	2026-05-11	香港	多云有阵雨	31	26	85	70	11	未来几日高温潮湿，门店需加强冷链管理，避免生鲜损耗。	2026-05-11 05:39:56	2026-05-11 05:39:56
6	3	2026-05-30	香港	多云转雷阵雨	31	26	85	70	8	天气炎热有雨，建议门店备足冷饮和雨具，注意防霉防潮。	2026-05-30 07:07:03	2026-05-30 07:07:03
7	1	2025-04-11	香港	多云转阵雨	25	20	85	70	5	今日有雨，记得带伞，生鲜配送注意防潮	2026-05-30 08:09:09	2026-05-30 08:09:09
8	1	2025-03-06	香港	多云有阵雨	24	19	85	60	3	今日有雨且湿度高，请加强生鲜冷藏保鲜措施。	2026-05-30 08:53:14	2026-05-30 08:53:14
9	1	2025-04-10	香港	多云转晴	26	20	75	10	8	今日阳光充足，适合晾晒和户外活动，生鲜门店可适当增加冷饮和水果备货。	2026-05-30 10:56:45	2026-05-30 10:56:45
10	1	2025-03-19	香港	多云转阵雨	25	20	80	60	5	今日天气温暖潮湿，偶有阵雨，出行请带伞。	2026-05-30 21:47:43	2026-05-30 21:47:43
11	1	2026-05-31	香港	多云有阵雨	32	26	85	70	8	今日有雨，出门请带伞，生鲜食材注意防潮保鲜。	2026-05-31 09:38:11	2026-05-31 09:38:11
12	1	2025-07-18	香港	多云转雷阵雨	33	28	80	60	11	今日有雷阵雨，生鲜门店请注意防潮防雨，及时补货，确保商品新鲜。	2026-06-01 18:14:07	2026-06-01 18:14:07
13	1	2025-07-02	香港	雷阵雨	32	26	85	80	7	天气炎热且有雷阵雨，建议室内活动，出门携带雨具。	2026-06-11 22:20:55	2026-06-11 22:20:55
14	1	2025-07-12	香港	晴转多云	33	28	80	60	11	高温高湿天气，生鲜商品易腐，请加强冷链保鲜，及时补货。	2026-06-11 22:42:25	2026-06-11 22:42:25
15	1	2025-03-30	香港	多云转阵雨	25	20	85	60	5	天气潮湿有雨，生鲜门店请注意防潮和通风。	2026-06-12 00:43:05	2026-06-12 00:43:05
16	1	2026-06-12	香港	多云有阵雨	31	26	85	70	6	今日有阵雨，记得带伞，海鲜需及时保鲜，注意防潮。	2026-06-12 05:21:58	2026-06-12 05:21:58
17	1	2025-04-02	香港	多云转阵雨	28	23	82	65	6	天气潮湿，鲜果易腐，请加强冷藏保鲜，注意通风除湿。	2026-06-12 19:43:26	2026-06-12 19:43:26
18	1	2025-03-28	香港	多云	25	18	65	30	5	今天适合出门，注意防晒。	2026-06-12 19:43:34	2026-06-12 19:43:34
\.


--
-- Data for Name: wework_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wework_users (id, user_id, wework_userid, wework_openid, department_ids, bound_at) FROM stdin;
\.


--
-- Name: ai_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ai_messages_id_seq', 588, true);


--
-- Name: ai_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ai_sessions_id_seq', 149, true);


--
-- Name: app_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_settings_id_seq', 3, true);


--
-- Name: attendance_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.attendance_records_id_seq', 1, true);


--
-- Name: chat_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.chat_logs_id_seq', 209, true);


--
-- Name: competitor_hot_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.competitor_hot_products_id_seq', 1, true);


--
-- Name: competitor_price_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.competitor_price_records_id_seq', 1, true);


--
-- Name: competitor_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.competitor_products_id_seq', 1, true);


--
-- Name: competitors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.competitors_id_seq', 1, true);


--
-- Name: custom_report_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.custom_report_templates_id_seq', 1, true);


--
-- Name: customer_follow_ups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customer_follow_ups_id_seq', 1, false);


--
-- Name: customer_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customer_order_items_id_seq', 1, false);


--
-- Name: customer_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customer_orders_id_seq', 1, false);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customers_id_seq', 1, false);


--
-- Name: daily_operation_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.daily_operation_logs_id_seq', 621, true);


--
-- Name: damage_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.damage_records_id_seq', 17, true);


--
-- Name: dashboard_configs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dashboard_configs_id_seq', 1, true);


--
-- Name: employee_store_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employee_store_history_id_seq', 1, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, true);


--
-- Name: expense_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.expense_categories_id_seq', 5, true);


--
-- Name: expenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.expenses_id_seq', 85, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: industries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.industries_id_seq', 12, true);


--
-- Name: intelligence_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.intelligence_reports_id_seq', 1, true);


--
-- Name: inventory_daily_snapshots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_daily_snapshots_id_seq', 543, true);


--
-- Name: inventory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_id_seq', 330, true);


--
-- Name: inventory_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inventory_transactions_id_seq', 596, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 1, true);


--
-- Name: menu_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.menu_templates_id_seq', 12, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 60, true);


--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.organizations_id_seq', 1, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permissions_id_seq', 43, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 167, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.posts_id_seq', 18, true);


--
-- Name: product_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_categories_id_seq', 6, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 196, true);


--
-- Name: promotion_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promotion_items_id_seq', 1, true);


--
-- Name: promotion_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promotion_reviews_id_seq', 1, true);


--
-- Name: promotion_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promotion_rules_id_seq', 1, true);


--
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, true);


--
-- Name: purchase_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_order_items_id_seq', 326, true);


--
-- Name: purchase_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.purchase_orders_id_seq', 56, true);


--
-- Name: quick_action_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quick_action_items_id_seq', 224, true);


--
-- Name: quick_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quick_actions_id_seq', 100, true);


--
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.regions_id_seq', 1, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, true);


--
-- Name: resumes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.resumes_id_seq', 25, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: saas_integrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.saas_integrations_id_seq', 1, true);


--
-- Name: salary_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.salary_records_id_seq', 1, true);


--
-- Name: sales_daily_summaries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_daily_summaries_id_seq', 75, true);


--
-- Name: sales_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_order_items_id_seq', 80, true);


--
-- Name: sales_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_orders_id_seq', 80, true);


--
-- Name: sales_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sales_uploads_id_seq', 9, true);


--
-- Name: schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schedules_id_seq', 1, true);


--
-- Name: stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stores_id_seq', 4, true);


--
-- Name: supplier_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supplier_products_id_seq', 21, true);


--
-- Name: supplier_refund_claim_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supplier_refund_claim_items_id_seq', 1, true);


--
-- Name: supplier_refund_claims_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.supplier_refund_claims_id_seq', 1, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 3, true);


--
-- Name: user_store_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_store_roles_id_seq', 14, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 14, true);


--
-- Name: weather_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.weather_logs_id_seq', 18, true);


--
-- Name: wework_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wework_users_id_seq', 1, true);


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
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: industries industries_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.industries
    ADD CONSTRAINT industries_slug_unique UNIQUE (slug);


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
-- Name: menu_templates menu_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_templates
    ADD CONSTRAINT menu_templates_pkey PRIMARY KEY (id);


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
-- Name: industries_enabled_sort_order_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX industries_enabled_sort_order_index ON public.industries USING btree (enabled, sort_order);


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
-- Name: menu_templates_industry_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX menu_templates_industry_is_active_index ON public.menu_templates USING btree (industry, is_active);


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
-- Name: quick_actions_industry_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX quick_actions_industry_index ON public.quick_actions USING btree (industry);


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
-- Name: quick_actions quick_actions_menu_template_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quick_actions
    ADD CONSTRAINT quick_actions_menu_template_id_foreign FOREIGN KEY (menu_template_id) REFERENCES public.menu_templates(id) ON DELETE SET NULL;


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

\unrestrict noOc03XCHDOMw2lyP6Qy2L3Gleyd7YRF47OOnap81aqjTfquLqKHJR6Ta3h4ewi

