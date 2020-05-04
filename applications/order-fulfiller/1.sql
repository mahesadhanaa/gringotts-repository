--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Debian 11.7-2.pgdg90+1)
-- Dumped by pg_dump version 12.2

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
-- Name: auto_grant_func(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.auto_grant_func() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    grant all on all tables in schema public to engineers;
    grant all on all sequences in schema public to engineers;
    grant select on all tables in schema public to readonly;
    grant select on all sequences in schema public to readonly;
    grant all on all tables in schema public to apps;
    grant all on all sequences in schema public to apps;
END;
$$;


SET default_tablespace = '';

--
-- Name: api_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_log (
    id integer NOT NULL,
    order_id character varying(255),
    provider_code character varying(255),
    request jsonb,
    response jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: api_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.api_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.api_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: result; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.result (
    id integer NOT NULL,
    inquiry_id character varying(255),
    order_id character varying(255) NOT NULL,
    ref_id character varying(255),
    provider_code character varying(255),
    product_code character varying(255),
    customer_no character varying(255),
    status character varying(255),
    error character varying(255),
    attachment jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: result_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.result ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: result_price; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.result_price (
    id integer NOT NULL,
    result_id integer,
    item_price numeric(10,2),
    admin_price numeric(10,2),
    commission numeric(10,2),
    cashback numeric(10,2),
    cogs numeric(10,2),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: result_price_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.result_price ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.result_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: task; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task (
    id integer NOT NULL,
    order_id character varying(255) NOT NULL,
    inquiry_id character varying(255),
    ref_id character varying(255),
    amount numeric(10,2),
    status character varying(255) NOT NULL,
    error character varying(255),
    providers character varying(255),
    stage character varying(255),
    product_code character varying(255),
    provider_code character varying(255),
    customer_no character varying(255),
    callback_url text,
    due timestamp with time zone NOT NULL,
    expiry_date timestamp with time zone NOT NULL,
    queued_at timestamp with time zone NOT NULL,
    issued_at timestamp with time zone NOT NULL,
    exit_waiting_at timestamp with time zone NOT NULL,
    last_run_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: task_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.task ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: api_log api_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_log
    ADD CONSTRAINT api_log_pkey PRIMARY KEY (id);


--
-- Name: result result_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.result
    ADD CONSTRAINT result_pkey PRIMARY KEY (id);


--
-- Name: result_price result_price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.result_price
    ADD CONSTRAINT result_price_pkey PRIMARY KEY (id);


--
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: order_fulfiller_api_log_result_id_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_api_log_result_id_provider_code ON public.api_log USING btree (order_id, provider_code);


--
-- Name: order_fulfiller_result_inquiry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_result_inquiry_id ON public.result USING btree (inquiry_id);


--
-- Name: order_fulfiller_result_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_result_order_id ON public.result USING btree (order_id);


--
-- Name: order_fulfiller_result_price_result_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_result_price_result_id ON public.result_price USING btree (result_id);


--
-- Name: order_fulfiller_result_ref_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_result_ref_id ON public.result USING btree (ref_id);


--
-- Name: order_fulfiller_task_inquiry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_task_inquiry_id ON public.task USING btree (inquiry_id);


--
-- Name: order_fulfiller_task_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_task_order_id ON public.task USING btree (order_id);


--
-- Name: order_fulfiller_task_product_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_task_product_code ON public.task USING btree (product_code);


--
-- Name: order_fulfiller_task_provider_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX order_fulfiller_task_provider_code ON public.task USING btree (provider_code);


--
-- Name: auto_grant_trigger; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER auto_grant_trigger ON ddl_command_end
         WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS')
   EXECUTE FUNCTION public.auto_grant_func();


--
-- Name: order_fulfiller_migration; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION order_fulfiller_migration FOR ALL TABLES WITH (publish = 'insert, update, delete, truncate');


--
-- PostgreSQL database dump complete
--