using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lesson68 : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        #region ��Ҫ֪ʶ�ع�

        #region 1.ǰ����Ⱦ·������δ����Դ
        //����Pass
        //Base Pass��������Ⱦͨ����
        //Additional Pass��������Ⱦͨ����
        #endregion

        #region 2.��Shader��������ж϶��ֹ�Դ
        //#if defined(_DIRECTIONAL_LIGHT)
        //  ƽ�й��߼�
        //#elif defined (_POINT_LIGHT)
        //  ���Դ�߼�
        //#elif defined (_SPOT_LIGHT)
        //  �۹���߼�
        //#else
        //  �����߼�
        //#endif
        #endregion

        #region 3.���Դ˥��ֵ����
        // float3 lightCoord = mul(unity_WorldToLight, float4(worldPos, 1)).xyz;
        // fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).xx).UNITY_ATTEN_CHANNEL;
        #endregion

        #region 4.�۹��˥��ֵ����
        // float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
        // fixed atten = (lightCoord.z > 0) * //��һ��
        // tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * //�ڶ���
        // tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL; //������
        #endregion

        #endregion

        #region ֪ʶ�� ǰ����Ⱦ·���д�����ֹ�Դ���ۺ�ʵ��
        //��Ҫ���裺
        //1.�½�һ��Shader�ļ���ɾ���������ô���

        //2.����Lesson45�е�Blinn-Phong����ģ�͵���ƬԪ����

        //3.�����Ѵ��ڵ�Pass���������ǵ�BasePass��������Ⱦͨ����
        //  ������ҪΪ������һ������ָ��#pragma multi_compile_fwdbase	
        //  ��ָ����Ա�֤������Shader��ʹ�ù���˥���ȹ��յȱ������Ա���ȷ��ֵ
        //  ���һ�������Ǳ��� BasePass �����б���

        //4.����BasePass�����������޸����ǵ�Additional Pass��������Ⱦͨ����

        //5.LightMode ��Ϊ ForwardAdd

        //6.����������Blend One One ��ʾ������� ���Լ���Ч��

        //7.�������ָ��#pragma multi_compile_fwdadd
        //  ��ָ�֤�����ڸ�����Ⱦͨ�����ܷ��ʵ���ȷ�Ĺ��ձ���
        //  ���һ�������Ǳ���Additional Pass�����б���

        //8.�޸���ش��룬���ڲ�ͬ�Ĺ�������������˥��ֵ
        //  8-1:��ķ�����㷽���޸�
        //  8-2:���ڲ�ͬ�������ͼ���˥��ֵ
        #endregion
    }

    // Update is called once per frame
    void Update()
    {

    }
}
