PGDMP  *                     }            HagaseUnEcommercee    14.13    16.4                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17494    HagaseUnEcommercee    DATABASE     �   CREATE DATABASE "HagaseUnEcommercee" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Mexico.1252';
 $   DROP DATABASE "HagaseUnEcommercee";
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false                       0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    4            �            1259    17496    products    TABLE     g  CREATE TABLE public.products (
    "productId" integer NOT NULL,
    "productImage" character varying(420) NOT NULL,
    "productName" character varying(120) NOT NULL,
    "productPrice" integer NOT NULL,
    "productDescription" character varying(500) NOT NULL,
    "productCategory" character varying(20) NOT NULL,
    "quantityProduct" integer NOT NULL
);
    DROP TABLE public.products;
       public         heap    postgres    false    4            �            1259    17495    products_productId_seq    SEQUENCE     �   ALTER TABLE public.products ALTER COLUMN "productId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."products_productId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    210    4            �            1259    17510    shoppingCart    TABLE     �   CREATE TABLE public."shoppingCart" (
    "cartId" integer NOT NULL,
    "userId" integer NOT NULL,
    "productId" integer NOT NULL
);
 "   DROP TABLE public."shoppingCart";
       public         heap    postgres    false    4            �            1259    17509    shoppingCart_cartId_seq    SEQUENCE     �   ALTER TABLE public."shoppingCart" ALTER COLUMN "cartId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."shoppingCart_cartId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214    4            �            1259    17504    users    TABLE     �   CREATE TABLE public.users (
    "userId" integer NOT NULL,
    "userName" character varying(30) NOT NULL,
    "userImage" character varying(150) NOT NULL,
    "userPasword" character varying(15) NOT NULL,
    "userRol" character varying(10) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false    4            �            1259    17503    users_userId_seq    SEQUENCE     �   ALTER TABLE public.users ALTER COLUMN "userId" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."users_userId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    4    212            �          0    17496    products 
   TABLE DATA           �   COPY public.products ("productId", "productImage", "productName", "productPrice", "productDescription", "productCategory", "quantityProduct") FROM stdin;
    public          postgres    false    210   }       �          0    17510    shoppingCart 
   TABLE DATA           I   COPY public."shoppingCart" ("cartId", "userId", "productId") FROM stdin;
    public          postgres    false    214          �          0    17504    users 
   TABLE DATA           \   COPY public.users ("userId", "userName", "userImage", "userPasword", "userRol") FROM stdin;
    public          postgres    false    212   :                  0    0    products_productId_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."products_productId_seq"', 6, true);
          public          postgres    false    209                       0    0    shoppingCart_cartId_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."shoppingCart_cartId_seq"', 1, false);
          public          postgres    false    213                       0    0    users_userId_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."users_userId_seq"', 1, false);
          public          postgres    false    211            g           2606    17502    products products_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY ("productId");
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    210            k           2606    17514    shoppingCart shoppingCart_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."shoppingCart"
    ADD CONSTRAINT "shoppingCart_pkey" PRIMARY KEY ("cartId");
 L   ALTER TABLE ONLY public."shoppingCart" DROP CONSTRAINT "shoppingCart_pkey";
       public            postgres    false    214            i           2606    17508    users user_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_pkey PRIMARY KEY ("userId");
 9   ALTER TABLE ONLY public.users DROP CONSTRAINT user_pkey;
       public            postgres    false    212            l           2606    17515    shoppingCart productId    FK CONSTRAINT     �   ALTER TABLE ONLY public."shoppingCart"
    ADD CONSTRAINT "productId" FOREIGN KEY ("productId") REFERENCES public.products("productId");
 D   ALTER TABLE ONLY public."shoppingCart" DROP CONSTRAINT "productId";
       public          postgres    false    214    3175    210            m           2606    17520    shoppingCart userId    FK CONSTRAINT     }   ALTER TABLE ONLY public."shoppingCart"
    ADD CONSTRAINT "userId" FOREIGN KEY ("userId") REFERENCES public.users("userId");
 A   ALTER TABLE ONLY public."shoppingCart" DROP CONSTRAINT "userId";
       public          postgres    false    214    212    3177            �   �   x�3�,-���I,(�/��RF�  �*�'�f�+�T(�9͸9s�K�S�*R���
�9}A|w_�'?=�$59C����pZ����?���$39_!9?O�85�8�H��5�_��ԛ3 �(3���"�|1��)W� qj8a      �      x������ � �      �      x������ � �     