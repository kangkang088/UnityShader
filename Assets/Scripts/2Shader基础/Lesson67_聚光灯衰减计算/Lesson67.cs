using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson67 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region ֪ʶ��һ �۹��Ĭ��Cookie
        //����֪���ƹ��������һ��Cookie������������������������ͼƬ��
        //����ƽ�й�͵��Դ��Ĭ���ǲ����ṩ�κι���������Ϣ��
        //���Ƕ��ھ۹����˵
        //Unity��Ĭ��Ϊ���ṩһ��Cookie��������
        //��Ҫ������ģ��۹�Ƶ�������
        //����ʱ ����������
        //_LightTexture0 �洢����Cookie������Ϣ
        //_LightTextureB0 �洢���ǹ���������Ϣ���������˥��ֵ

        //���
        //1.��ȡ�۹��˥��ֵʱ
        //  ��Ҫ��_LightTextureB0�н��в���
        //2.��ȡ���ַ�Χ�������ʱ
        //  ��Ҫ��_LightTexture0�н��в���
        #endregion

        #region ֪ʶ��� �۹��˥������
        //1.�����������ռ�ת������Դ�ռ�
        // float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
        // ע�⣺
        // ��������ת����͵��Դ��ͬ����
        // ���Դֻ���ȡ���е�xyz
        // ���۹�ƻ��ȡ���е�xyzw
        // ������Ϊ�ھ۹�ƹ�Դ�ռ��µ�wֵ�����⺬��
        // ���������ļ���

        //2.���ù�Դ�ռ��µ�������Ϣ
        //  ���ǻ�ͨ��3������ȥ��ȡ�۹�Ƶ�˥����Ϣ
        //  fixed atten = (lightCoord.z > 0) * //��һ��
        //  tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * //�ڶ���
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; //������

        //  �������ȷ����͵��Դ��ͬ�Ĳ��֡���������
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; 
        //  ��һ���Ĺ���͵��Դ����һ�£�ֱ�Ӹ��ݾ����Դԭ������ƽ���ӹ��������л�ȡ˥��ֵ
        //  ��Ҫע�����
        //  1.�۹�ƵĹ���˥������Ϊ_LightTextureB0
        //  2.dot����ֻ�����xyz��w�������

        //  �����������������ڽ��з�Χ�жϵĲ��֡�����һ������
        //  ��һ����(lightCoord.z > 0) 
        //      CG�﷨��û����ʾ��bool���ͣ�һ������� 0 ��ʾfalse��1��ʾtrue
        //      Ҳ����˵lightCoord.z > 0�ķ���ֵ����������ʱΪ1������������Ϊ0
        //      �����z�������ʵ�� Ŀ��� ����� �۹�������� ����
        //      ��� lightCoord.z <= 0 ֤���ھ۹�����䷽��ı��棬�Ͳ�Ӧ���ܵ��۹�Ƶ�Ӱ��
        //      Ҳ����˵��һ������Ҫ���ã����������������Ƿ��ܵ��۹�ƹ��յ�Ӱ��

        //  �ڶ�����tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w
        //      ������ǰ�ڽ����������ʱ�������һ�� ������ �� ƽ�� �Ĳ���
        //      ���磺uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
        //      ���ڶ����е� lightCoord.xy / lightCoord.w + 0.5 ��ʵҲ������������һ������
        //      ����������ҪĿ������Ϊ��
        //      ������Ҫ��uv����ӳ�䵽0~1�ķ�Χ���ٴ������в���
        //      lightCoord.xy / lightCoord.w �������ź� x,y��ȡֵ��Χ��-0.5~0.5֮��
        //      �ټ���0.5��x,y��ȡֵ��Χ����0~1֮�䣬����Խ�����ȷ�����������
        //      ��lightCoord.xy / lightCoord.w ����Ϊ�۹���кܶ�����
        //      ������Ҫ�Ѹ������ӳ�䵽�������Ͻ��в���

        //  ��������ܽ�һ��
        //  ���Ƹ��ӵľ۹�ƹ���˥�����㷽ʽ
        //  ��ʵ������ ������˥���� �� ����˥�� ��ͬ������
        //  ��һ�����ж��Ƿ����л����յ��� ���õ�Ϊ1��������Ϊ0 
        //  fixed atten = (lightCoord.z > 0) * 
        //  �ڶ���������ƽ�ƣ�ӳ�䵽����������� ���������������Ϣ����˥������
        //  tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * 
        //  ���������ӹ���˥��������ȡ��������õ���˥��ֵ
        //  tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; 
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
